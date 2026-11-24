import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../models/profile_models.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return ProfileRepository(apiClient, storageService);
});

class ProfileRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  ProfileRepository(this._apiClient, this._storageService);

  Future<UserProfileResponse> fetchProfile() async {
    final response = await _apiClient.get(ApiEndpoints.profile);
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final profileResponse = UserProfileResponse.fromJson(rawData);
      // Cache details in storage
      if (profileResponse.profile.name.isNotEmpty) {
        await _storageService.saveUserName(profileResponse.profile.name);
      }
      if (profileResponse.profile.phoneNumber != null &&
          profileResponse.profile.phoneNumber!.isNotEmpty) {
        await _storageService.savePhone(profileResponse.profile.phoneNumber!);
      }
      if (profileResponse.profile.id > 0) {
        await _storageService.saveUserId(profileResponse.profile.id.toString());
      }
      return profileResponse;
    }
    throw ApiException(message: 'Invalid profile data from server');
  }

  Future<UpdateProfileResponse> updateProfile({
    required String name,
    required String bio,
    required DateTime dob,
    String? imagePath,
  }) async {
    final formattedDob = DateFormat('yyyy-MM-dd').format(dob);

    dynamic requestData;
    if (imagePath != null &&
        imagePath.isNotEmpty &&
        !imagePath.startsWith('http')) {
      final map = <String, dynamic>{
        'name': name.trim(),
        'bio': bio.trim(),
        'date_of_birth': formattedDob,
      };
      final file = File(imagePath);
      if (file.existsSync()) {
        map['profile_picture'] = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        );
      }
      requestData = FormData.fromMap(map);
    } else {
      requestData = {
        'name': name.trim(),
        'bio': bio.trim(),
        'date_of_birth': formattedDob,
      };
    }

    Response response;
    try {
      response = await _apiClient.patch(
        ApiEndpoints.profile,
        data: requestData,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 405) {
        response = await _apiClient.put(
          ApiEndpoints.profile,
          data: requestData,
        );
      } else {
        rethrow;
      }
    }

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final updateResponse = UpdateProfileResponse.fromJson(rawData);
      if (updateResponse.profile.name.isNotEmpty) {
        await _storageService.saveUserName(updateResponse.profile.name);
      }
      return updateResponse;
    }
    throw ApiException(message: 'Failed to update profile');
  }
}
