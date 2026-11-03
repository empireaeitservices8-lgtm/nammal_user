import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  // Storage Keys
  static const String _keyToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Secure Token Methods
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyToken, value: token);
    await _prefs?.setBool(_keyIsLoggedIn, true);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  //  User Session Methods
  Future<void> saveUserId(String userId) async {
    await _prefs?.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return _prefs?.getString(_keyUserId);
  }

  bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  //Clear Session (Logout)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs?.clear();
  }
}
