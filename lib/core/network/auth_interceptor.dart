import 'package:dio/dio.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Read JWT token from secure storage
    final token = await _storageService.getToken();

    if (token != null && token.isNotEmpty) {
      if (token.startsWith('Bearer ') || token.startsWith('Token ')) {
        options.headers['Authorization'] = token;
      } else if (token.length == 40 && !token.contains('.')) {
        // Django REST Framework default Token authentication
        options.headers['Authorization'] = 'Token $token';
      } else {
        options.headers['Authorization'] = 'Token $token';
      }
    }

    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If token is invalid or expired
    if (err.response?.statusCode == 401) {
      await _storageService.clearAll();
      // Session cleared, app will redirect to login
    }
    return handler.next(err);
  }
}
