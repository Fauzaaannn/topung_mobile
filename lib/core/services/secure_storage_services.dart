import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';

class SecureStorageService implements ISecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final String _tokenKey = 'access_token';
  final String _roleKey = 'role';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> saveRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  @override
  Future<String?> getToken() async => _storage.read(key: _tokenKey);

  @override
  Future<String?> getRole() async => _storage.read(key: _roleKey);

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> deleteRole() async {
    await _storage.delete(key: _roleKey);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<void> set(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> get(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
