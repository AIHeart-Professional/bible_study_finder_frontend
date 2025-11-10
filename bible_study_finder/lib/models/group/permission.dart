class Permission {
  final String id;
  final String action;
  final String description;

  Permission({
    required this.id,
    required this.action,
    required this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] ?? '',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'description': description,
    };
  }
}

