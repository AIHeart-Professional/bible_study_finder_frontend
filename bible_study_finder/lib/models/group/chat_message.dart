class ChatMessage {
  final String id;
  final String userId;
  final String username;
  final String message;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.message,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      message: json['message'] ?? '',
      sentAt: DateTime.parse(json['sentAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'message': message,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}

