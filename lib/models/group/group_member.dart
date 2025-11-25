class GroupMember {
  final String userId;
  final String username;
  final String email;
  final String? portraitUrl;
  final String role;
  final DateTime joinedAt;

  const GroupMember({
    required this.userId,
    required this.username,
    required this.email,
    this.portraitUrl,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    DateTime parseJoinedAt(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return DateTime.now();
        }
      }
      if (dateValue is Map && dateValue.containsKey('\$date')) {
        final dateStr = dateValue['\$date'];
        if (dateStr is String) {
          try {
            return DateTime.parse(dateStr);
          } catch (e) {
            return DateTime.now();
          }
        }
      }
      return DateTime.now();
    }

    return GroupMember(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      portraitUrl: json['portraitUrl'],
      role: json['role'] ?? '',
      joinedAt: parseJoinedAt(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      if (portraitUrl != null) 'portraitUrl': portraitUrl,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}

