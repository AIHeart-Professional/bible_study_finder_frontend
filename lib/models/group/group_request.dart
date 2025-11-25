class GroupRequest {
  final String id;
  final String groupId;
  final String userId;
  final String? username;
  final String requestMessage;
  final DateTime createdAt;
  final String status; // pending, approved, rejected

  GroupRequest({
    required this.id,
    required this.groupId,
    required this.userId,
    this.username,
    required this.requestMessage,
    required this.createdAt,
    this.status = 'pending',
  });

  factory GroupRequest.fromJson(Map<String, dynamic> json) {
    return GroupRequest(
      id: _extractId(json['id'] ?? json['_id'] ?? ''),
      groupId: _extractId(json['groupId'] ?? ''),
      userId: _extractId(json['userId'] ?? ''),
      username: json['username'] as String?,
      requestMessage: json['requestMessage'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      if (username != null) 'username': username,
      'requestMessage': requestMessage,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
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

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is String) {
      return DateTime.parse(dateValue);
    }
    if (dateValue is Map) {
      if (dateValue.containsKey(r'$date')) {
        final date = dateValue[r'$date'];
        if (date is int) {
          return DateTime.fromMillisecondsSinceEpoch(date);
        }
        if (date is String) {
          return DateTime.parse(date);
        }
      }
      if (dateValue.containsKey('date')) {
        final date = dateValue['date'];
        if (date is int) {
          return DateTime.fromMillisecondsSinceEpoch(date);
        }
        if (date is String) {
          return DateTime.parse(date);
        }
      }
    }
    return DateTime.now();
  }
}

