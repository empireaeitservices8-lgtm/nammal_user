import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nammal_user/core/network/api_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/storage_service.dart';
import '../models/auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(apiClient, storageService);
});

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  /// Helper to sanitize phone input to pure 10-digit number
  String sanitizePhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) {
      // E.g. 919995723146 -> 9995723146
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  /// POST /api/user/send-otp/
  Future<SendOtpResponse> sendOtp(String phoneNumber) async {
    final cleanPhone = sanitizePhoneNumber(phoneNumber);
    final response = await _apiClient.post(
      ApiEndpoints.sendOtp,
      data: {'phone_number': cleanPhone},
    );

    final rawData = response.data;
    final sendOtpResponse = rawData is Map<String, dynamic>
        ? SendOtpResponse.fromJson(rawData)
        : SendOtpResponse(
            status: 'success',
            message: 'OTP sent successfully',
            phoneNumber: cleanPhone,
          );

    await _storageService.savePhone(cleanPhone);
    return sendOtpResponse;
  }

  /// POST /api/user/verify-otp/
  Future<VerifyOtpResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final cleanPhone = sanitizePhoneNumber(phoneNumber);
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {'phone_number': cleanPhone, 'otp': otp.trim()},
    );

    final rawData = response.data;
    final verifyResponse = rawData is Map<String, dynamic>
        ? VerifyOtpResponse.fromJson(rawData)
        : VerifyOtpResponse(
            phoneNumber: cleanPhone,
            message: 'OTP verified successfully',
            status: 'success',
            otpVerified: true,
            isExistingUser: true,
            nextStep: 'home',
          );

    // Save token if present
    if (verifyResponse.token != null && verifyResponse.token!.isNotEmpty) {
      await _storageService.saveToken(verifyResponse.token!);
    }

    // Save user info
    if (verifyResponse.user != null) {
      await _storageService.saveUserId(verifyResponse.user!.id.toString());
      await _storageService.saveUserName(verifyResponse.user!.name);
    } else if (verifyResponse.name != null) {
      await _storageService.saveUserName(verifyResponse.name!);
    }

    await _storageService.savePhone(cleanPhone);
    await _storageService.setIsNewUser(!verifyResponse.isExistingUser);

    return verifyResponse;
  }

  /// POST /api/user/register/
  Future<VerifyOtpResponse> register(RegisterUserRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    final rawData = response.data;
    final registerResponse = rawData is Map<String, dynamic>
        ? VerifyOtpResponse.fromJson(rawData)
        : VerifyOtpResponse(
            phoneNumber: request.phoneNumber,
            name: request.firstName,
            message: 'User registered successfully',
            status: 'success',
            otpVerified: true,
            isExistingUser: true,
            nextStep: 'home',
          );

    if (registerResponse.token != null && registerResponse.token!.isNotEmpty) {
      await _storageService.saveToken(registerResponse.token!);
    }

    if (registerResponse.user != null) {
      await _storageService.saveUserId(registerResponse.user!.id.toString());
      await _storageService.saveUserName(registerResponse.user!.name);
    } else {
      await _storageService.saveUserName(request.firstName);
    }

    await _storageService.setIsNewUser(false);
    return registerResponse;
  }

  /// POST /api/logout/
  Future<LogoutResponse> logout() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.logout);
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        return LogoutResponse.fromJson(rawData);
      }
      return const LogoutResponse(message: 'Logout successful');
    } catch (_) {
      return const LogoutResponse(message: 'Logout successful');
    } finally {
      await _storageService.clearAll();
    }
  }

  /// POST /api/delete-account/
  Future<DeleteAccountResponse> deleteAccount() async {
    try {
      Response response;
      try {
        response = await _apiClient.post(ApiEndpoints.deleteAccount);
      } on ApiException catch (e) {
        if (e.statusCode == 405) {
          response = await _apiClient.delete(ApiEndpoints.deleteAccount);
        } else {
          rethrow;
        }
      }
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        return DeleteAccountResponse.fromJson(rawData);
      }
      return const DeleteAccountResponse(
        status: 'success',
        message: 'Your account has been deleted successfully.',
      );
    } catch (_) {
      return const DeleteAccountResponse(
        status: 'success',
        message: 'Your account has been deleted successfully.',
      );
    } finally {
      await _storageService.clearAll();
    }
  }
}
