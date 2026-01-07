class AppMessage {
  final String id;
  final String sender;
  final String role;
  final String preview;
  final String time;
  final int unread;

  AppMessage({
    required this.id,
    required this.sender,
    required this.role,
    required this.preview,
    required this.time,
    required this.unread,
  });

  factory AppMessage.fromJson(Map<String, dynamic> json) {
    return AppMessage(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? 'Inconnu',
      role: json['role'] ?? '',
      preview: json['preview'] ?? '',
      time: json['time'] ?? '',
      unread: json['unread'] ?? 0,
    );
  }
}
