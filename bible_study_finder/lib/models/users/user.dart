class User {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final DateTime createdDate;
  final DateTime updatedDate;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.createdDate,
    required this.updatedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      createdDate: DateTime.parse(json['created_date'] ?? DateTime.now().toIso8601String()),
      updatedDate: DateTime.parse(json['updated_date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool authenticated;
  final String message;
  final User? user;
  final String? token;

  LoginResponse({
    required this.authenticated,
    required this.message,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      authenticated: json['authenticated'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'],
    );
  }
}

class CreateUserRequest {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final List<String>? attendedChurches;

  CreateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    this.attendedChurches,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'password': password,
      if (attendedChurches != null) 'attended_churches': attendedChurches,
    };
  }
}

class CreateUserResponse {
  final bool created;
  final String message;

  CreateUserResponse({
    required this.created,
    required this.message,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      created: json['created'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

