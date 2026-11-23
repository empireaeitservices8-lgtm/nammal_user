import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../models/auth_models.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserModel? user;
  final bool isLoggedIn;
  final bool isExistingUser;
  final String nextStep; // "home" or "onboarding"
  final bool otpSent;
  final String? currentPhone;
  final SendOtpResponse? otpResponse;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.isLoggedIn = false,
    this.isExistingUser = false,
    this.nextStep = 'home',
    this.otpSent = false,
    this.currentPhone,
    this.otpResponse,
  });

  bool get isNewUser => !isExistingUser;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
    bool? isLoggedIn,
    bool? isExistingUser,
    String? nextStep,
    bool? otpSent,
    String? currentPhone,
    SendOtpResponse? otpResponse,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isExistingUser: isExistingUser ?? this.isExistingUser,
      nextStep: nextStep ?? this.nextStep,
      otpSent: otpSent ?? this.otpSent,
      currentPhone: currentPhone ?? this.currentPhone,
      otpResponse: otpResponse ?? this.otpResponse,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final storageService = ref.watch(storageServiceProvider);
    return AuthState(
      isLoggedIn: storageService.isLoggedIn(),
      isExistingUser: !storageService.isNewUser(),
      currentPhone: storageService.getPhone(),
    );
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  StorageService get _storageService => ref.read(storageServiceProvider);

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<SendOtpResponse?> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cleanPhone = _repository.sanitizePhoneNumber(phoneNumber);
      final response = await _repository.sendOtp(cleanPhone);
      state = state.copyWith(
        isLoading: false,
        otpSent: response.isSuccess,
        currentPhone: cleanPhone,
        isExistingUser: response.isExistingUser,
        otpResponse: response,
      );
      return response;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to send OTP. Please check your connection.',
      );
      return null;
    }
  }

  Future<VerifyOtpResponse?> verifyOtp(String otp) async {
    final phone = state.currentPhone ?? _storageService.getPhone() ?? '';
    if (phone.isEmpty) {
      state = state.copyWith(
        error: 'Phone number missing. Please restart login.',
      );
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.verifyOtp(
        phoneNumber: phone,
        otp: otp,
      );
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        isExistingUser: response.isExistingUser,
        nextStep: response.nextStep,
        user: response.user,
      );
      return response;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Verification failed. Please try again.',
      );
      return null;
    }
  }

  Future<bool> register({
    required String firstName,
    required String gender,
    required String day,
    required String month,
    required String year,
    String? fcmToken,
  }) async {
    final phone = state.currentPhone ?? _storageService.getPhone() ?? '';
    if (phone.isEmpty) {
      state = state.copyWith(
        error: 'Phone number missing. Please restart login.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.register(
        RegisterUserRequest(
          phoneNumber: phone,
          firstName: firstName,
          gender: gender,
          day: day,
          month: month,
          year: year,
          fcmToken: fcmToken,
        ),
      );
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        isExistingUser: true,
        nextStep: 'home',
        user: response.user,
      );
      return response.isSuccess;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed. Please try again.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
