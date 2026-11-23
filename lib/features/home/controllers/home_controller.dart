import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/home_models.dart';
import '../repositories/home_repository.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final HomeScreenResponse? data;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    HomeScreenResponse? data,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    Future.microtask(() => loadHomeData());
    return const HomeState(isLoading: true);
  }

  HomeRepository get _repository => ref.read(homeRepositoryProvider);

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.fetchHomeData();
      state = state.copyWith(isLoading: false, data: response);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load home data. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    await loadHomeData();
  }
}

final homeControllerProvider =
    NotifierProvider<HomeController, HomeState>(HomeController.new);
