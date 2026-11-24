import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/wallet_models.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});

class WalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  Future<WalletResponse> fetchWallet() async {
    final response = await _apiClient.get(ApiEndpoints.walletBalance);
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return WalletResponse.fromJson(rawData);
    } else if (rawData is Map) {
      return WalletResponse.fromJson(Map<String, dynamic>.from(rawData));
    }
    throw ApiException(message: 'Invalid wallet data received from server');
  }

  Future<CreateOrderResponse> createOrder({
    required String packId,
    num? amount,
    int? coins,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.createPayment,
      data: {
        'pack_id': packId,
        if (amount != null) 'amount': amount,
        if (coins != null) 'coins': coins,
      },
    );
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return CreateOrderResponse.fromJson(rawData);
    } else if (rawData is Map) {
      return CreateOrderResponse.fromJson(Map<String, dynamic>.from(rawData));
    }
    throw ApiException(message: 'Invalid response from payment server');
  }

  Future<AddCoinsResponse> addCoins({required int coins}) async {
    final response = await _apiClient.post(
      ApiEndpoints.addCoins,
      data: {'coins': coins},
    );
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return AddCoinsResponse.fromJson(rawData);
    } else if (rawData is Map) {
      return AddCoinsResponse.fromJson(Map<String, dynamic>.from(rawData));
    }
    throw ApiException(message: 'Invalid response from coins server');
  }

  Future<dynamic> verifyPayment({
    required String orderId,
    required String paymentId,
    String? signature,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyPurchase,
      data: {
        'order_id': orderId,
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'payment_id': paymentId,
        if (signature != null) 'razorpay_signature': signature,
      },
    );
    return response.data;
  }

  Future<TransactionsResponse> fetchTransactions() async {
    final response = await _apiClient.get(ApiEndpoints.transactions);
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return TransactionsResponse.fromJson(rawData);
    } else if (rawData is Map) {
      return TransactionsResponse.fromJson(Map<String, dynamic>.from(rawData));
    }
    throw ApiException(message: 'Invalid transactions data from server');
  }
}
