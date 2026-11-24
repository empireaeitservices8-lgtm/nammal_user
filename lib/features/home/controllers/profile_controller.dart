import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/profile_models.dart';
import '../repositories/profile_repository.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  final UserProfileResponse? data;

  const ProfileState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    UserProfileResponse? data,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    Future.microtask(() => loadProfile());
    return const ProfileState(isLoading: true);
  }

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.fetchProfile();
      state = state.copyWith(isLoading: false, data: response);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile. Please try again.',
      );
    }
  }

  Future<UpdateProfileResponse?> updateProfile({
    required String name,
    required String bio,
    required DateTime dob,
    String? imagePath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.updateProfile(
        name: name,
        bio: bio,
        dob: dob,
        imagePath: imagePath,
      );
      final currentData = state.data;
      if (currentData != null) {
        final updatedData = UserProfileResponse(
          status: response.status,
          profile: response.profile,
          coins: currentData.coins,
          isOnline: currentData.isOnline,
          isOnCall: currentData.isOnCall,
          isVerified: currentData.isVerified,
          unreadNotifications: currentData.unreadNotifications,
          role: currentData.role,
        );
        state = state.copyWith(isLoading: false, data: updatedData);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return response;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile. Please try again.',
      );
      return null;
    }
  }

  Future<void> refresh() async {
    await loadProfile();
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);
