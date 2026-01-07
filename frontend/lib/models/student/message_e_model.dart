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
      id: json['userId'] ?? '',
      sender: json['name'] ?? 'Inconnu',
      role: json['email'] ?? '',
      preview: json['lastMessage'] ?? 'Aucun message',
      time: _formatTime(json['lastMessageTime']),
      unread: json['unreadCount'] ?? 0,
    );
  }

  static String _formatTime(dynamic timestamp) {
    try {
      if (timestamp == null) return '';
      
      DateTime dateTime;
      if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else if (timestamp is DateTime) {
        dateTime = timestamp;
      } else {
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}j';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}min';
      } else {
        return 'maintenant';
      }
    } catch (e) {
      return '';
    }
  }
}
