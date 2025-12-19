import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/users/user.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userLastNameKey = 'user_last_name';
  static const String _userUsernameKey = 'user_username';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userIdKey, value: user.id);
    await _storage.write(key: _userEmailKey, value: user.email);
    await _storage.write(key: _userFirstNameKey, value: user.firstName);
    await _storage.write(key: _userLastNameKey, value: user.lastName);
    await _storage.write(key: _userUsernameKey, value: user.username);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<User?> getUser() async {
    final userData = await _readAllUserData();
    if (!_hasAllUserData(userData)) {
      return null;
    }
    return _buildUserFromData(userData);
  }

  static Future<Map<String, String?>> _readAllUserData() async {
    return {
      'id': await _storage.read(key: _userIdKey),
      'email': await _storage.read(key: _userEmailKey),
      'firstName': await _storage.read(key: _userFirstNameKey),
      'lastName': await _storage.read(key: _userLastNameKey),
      'username': await _storage.read(key: _userUsernameKey),
    };
  }

  static bool _hasAllUserData(Map<String, String?> data) {
    return data.values.every((value) => value != null && value.isNotEmpty);
  }

  static User _buildUserFromData(Map<String, String?> data) {
    return User(
      id: data['id']!,
      firstName: data['firstName']!,
      lastName: data['lastName']!,
      username: data['username']!,
      email: data['email']!,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearAuth() async {
    final keys = _getAllKeys();
    for (final key in keys) {
      await _storage.delete(key: key);
    }
  }

  static List<String> _getAllKeys() {
    return [
      _tokenKey,
      _userIdKey,
      _userEmailKey,
      _userFirstNameKey,
      _userLastNameKey,
      _userUsernameKey,
    ];
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}














