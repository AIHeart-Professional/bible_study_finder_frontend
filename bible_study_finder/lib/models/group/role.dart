class Role {
  final String id;
  final String name;
  final List<String> permissions;

  Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: _extractId(json['id'] ?? json['_id'] ?? ''),
      name: json['name'] ?? '',
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      'name': name,
      'permissions': permissions,
    };
  }
}

