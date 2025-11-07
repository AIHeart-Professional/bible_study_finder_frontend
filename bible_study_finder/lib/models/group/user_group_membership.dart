class UserGroupMembership {
  final int groupId;
  final String groupName;
  final DateTime joinedDate;
  final bool isActive;
  final String role; // 'member', 'leader', 'co-leader', etc.
  final String? notes; // Personal notes about the group

  const UserGroupMembership({
    required this.groupId,
    required this.groupName,
    required this.joinedDate,
    required this.isActive,
    required this.role,
    this.notes,
  });

  factory UserGroupMembership.fromJson(Map<String, dynamic> json) {
    return UserGroupMembership(
      groupId: json['groupId'] ?? 0,
      groupName: json['groupName'] ?? '',
      joinedDate: DateTime.parse(json['joinedDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      role: json['role'] ?? 'member',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'joinedDate': joinedDate.toIso8601String(),
      'isActive': isActive,
      'role': role,
      'notes': notes,
    };
  }

  UserGroupMembership copyWith({
    int? groupId,
    String? groupName,
    DateTime? joinedDate,
    bool? isActive,
    String? role,
    String? notes,
  }) {
    return UserGroupMembership(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      joinedDate: joinedDate ?? this.joinedDate,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      notes: notes ?? this.notes,
    );
  }
}

