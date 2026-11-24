import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/wallet_models.dart';
import '../repositories/wallet_repository.dart';

class TransactionsState {
  final bool isLoading;
  final String? error;
  final TransactionsResponse? data;

  const TransactionsState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  TransactionsState copyWith({
    bool? isLoading,
    String? error,
    TransactionsResponse? data,
  }) {
    return TransactionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class TransactionsController extends Notifier<TransactionsState> {
  @override
  TransactionsState build() {
    Future.microtask(() => fetchTransactions());
    return const TransactionsState(isLoading: true);
  }

  WalletRepository get _repository => ref.read(walletRepositoryProvider);

  Future<void> fetchTransactions({bool isRefresh = false}) async {
    if (!isRefresh && state.data == null) {
      state = state.copyWith(isLoading: true, error: null);
    }
    try {
      final response = await _repository.fetchTransactions();
      state = state.copyWith(isLoading: false, data: response, error: null);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load transactions. Please try again.',
      );
    }
  }
}

final transactionsControllerProvider =
    NotifierProvider<TransactionsController, TransactionsState>(
  TransactionsController.new,
);
