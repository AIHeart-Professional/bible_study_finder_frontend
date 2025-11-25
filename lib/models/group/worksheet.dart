class Worksheet {
  final String id;
  final String groupId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Worksheet({
    required this.id,
    required this.groupId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Worksheet.fromJson(Map<String, dynamic> json) {
    return Worksheet(
      id: json['id'] ?? '',
      groupId: json['groupId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}


