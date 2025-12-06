import '../../models/users/user.dart';
import '../../apis/users/user_api.dart';
import '../../core/logging/logger.dart';

class UserService {
  static final _logger = getLogger('UserService');

  static Future<LoginResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      return await UserApi.loginApi(request);
    } catch (e, stackTrace) {
      _logger.error('Error logging in', error: e, stackTrace: stackTrace);
      throw Exception('Error logging in: $e');
    }
  }

  static Future<CreateUserResponse> createUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    List<String>? attendedChurches,
  }) async {
    try {
      final request = CreateUserRequest(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        attendedChurches: attendedChurches,
      );
      return await UserApi.createUserApi(request);
    } catch (e, stackTrace) {
      _logger.error('Error creating user', error: e, stackTrace: stackTrace);
      throw Exception('Error creating user: $e');
    }
  }
}

