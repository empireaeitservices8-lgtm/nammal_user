import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../models/home_models.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return HomeRepository(apiClient, storageService);
});

class HomeRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  HomeRepository(this._apiClient, this._storageService);

  Future<HomeScreenResponse> fetchHomeData() async {
    final response = await _apiClient.get(ApiEndpoints.home);
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final homeResponse = HomeScreenResponse.fromJson(rawData);
      if (homeResponse.user.name.isNotEmpty) {
        await _storageService.saveUserName(homeResponse.user.name);
      }
      if (homeResponse.user.id > 0) {
        await _storageService.saveUserId(homeResponse.user.id.toString());
      }
      return homeResponse;
    }
    throw ApiException(message: 'Invalid data format from home API');
  }
}
