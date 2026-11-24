import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/wallet_models.dart';
import '../repositories/wallet_repository.dart';

class WalletState {
  final bool isLoading;
  final String? error;
  final WalletResponse? data;

  const WalletState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  WalletState copyWith({
    bool? isLoading,
    String? error,
    WalletResponse? data,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class WalletController extends Notifier<WalletState> {
  @override
  WalletState build() {
    Future.microtask(() => fetchWallet());
    return const WalletState(isLoading: true);
  }

  WalletRepository get _repository => ref.read(walletRepositoryProvider);

  Future<void> fetchWallet({bool isRefresh = false}) async {
    if (!isRefresh && state.data == null) {
      state = state.copyWith(isLoading: true, error: null);
    }
    try {
      final response = await _repository.fetchWallet();
      state = state.copyWith(isLoading: false, data: response, error: null);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load wallet. Please try again.',
      );
    }
  }

  void updateBalance({required int newCoins, num? newWalletBalance}) {
    if (state.data != null) {
      final current = state.data!;
      final updated = WalletResponse(
        status: current.status,
        coins: newCoins,
        walletBalance: newWalletBalance ?? current.walletBalance,
        coinToInr: current.coinToInr,
        coinPacks: current.coinPacks,
        offers: current.offers,
        transactions: current.transactions,
      );
      state = state.copyWith(data: updated);
    }
  }

  Future<AddCoinsResponse> addCoins(int coins) async {
    final response = await _repository.addCoins(coins: coins);
    updateBalance(
      newCoins: response.newBalance,
      newWalletBalance: response.walletBalance,
    );
    return response;
  }
}

final walletControllerProvider =
    NotifierProvider<WalletController, WalletState>(WalletController.new);
