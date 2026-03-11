abstract class ISecureStorageService {
  Future<void> saveToken(String token);
  Future<void> saveRole(String role);

  Future<String?> getToken();
  Future<String?> getRole();

  Future<void> deleteToken();
  Future<void> deleteRole();
  Future<void> deleteAll();

  Future<void> set(String key, String value);
  Future<String?> get(String key);
  Future<void> delete(String key);
}
