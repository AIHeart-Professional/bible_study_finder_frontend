class GroupRole {
  final String id;
  final String userId;
  final String groupId;
  final String role;

  GroupRole({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.role,
  });

  factory GroupRole.fromJson(Map<String, dynamic> json) {
    return GroupRole(
      id: _extractId(json['id'] ?? json['_id'] ?? ''),
      userId: _extractId(json['userId'] ?? ''),
      groupId: _extractId(json['groupId'] ?? ''),
      role: json['role'] ?? '',
    );
  }

  static String _extractId(dynamic idValue) {
    if (idValue == null) return '';
    if (idValue is String) return idValue;
    if (idValue is Map) {
      if (idValue.containsKey(r'$oid')) {
        return idValue[r'$oid'].toString();
      }
      if (idValue.containsKey('oid')) {
        return idValue['oid'].toString();
      }
    }
    return idValue.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'groupId': groupId,
      'role': role,
    };
  }
}

