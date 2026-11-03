import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message:
              'Connection timed out. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final response = error.response;
        final statusCode = response?.statusCode;
        String errorMessage = 'Something went wrong. Please try again.';

        if (response?.data != null && response?.data is Map) {
          final data = response!.data as Map<String, dynamic>;
          errorMessage = data['message'] ?? data['error'] ?? errorMessage;
        }

        switch (statusCode) {
          case 400:
            return ApiException(message: errorMessage, statusCode: 400);
          case 401:
            return ApiException(
              message: 'Session expired. Please log in again.',
              statusCode: 401,
            );
          case 403:
            return ApiException(message: 'Access forbidden.', statusCode: 403);
          case 404:
            return ApiException(
              message: 'Requested resource not found.',
              statusCode: 404,
            );
          case 500:
          case 502:
          case 503:
            return ApiException(
              message: 'Server error. Please try again later.',
              statusCode: statusCode,
            );
          default:
            return ApiException(message: errorMessage, statusCode: statusCode);
        }

      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');

      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection detected.');

      default:
        return ApiException(
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }

  @override
  String toString() => message;
}
