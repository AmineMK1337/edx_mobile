class MessageModel {
  final String? id;
  final String senderId;
  final String recipientId;
  final String? courseId;
  final String content;
  final DateTime sentAt;
  final bool isRead;
  
  // Populated fields
  final Map<String, dynamic>? sender;
  final Map<String, dynamic>? recipient;

  MessageModel({
    this.id,
    required this.senderId,
    required this.recipientId,
    this.courseId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
    this.sender,
    this.recipient,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      senderId: json['sender'] is String ? json['sender'] : json['sender']?['_id'],
      recipientId: json['recipient'] is String ? json['recipient'] : json['recipient']?['_id'],
      courseId: json['course'] is String ? json['course'] : json['course']?['_id'],
      content: json['content'] ?? '',
      sentAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      isRead: json['isRead'] ?? false,
      sender: json['sender'] is Map ? json['sender'] : null,
      recipient: json['recipient'] is Map ? json['recipient'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'sender': senderId,
      'recipient': recipientId,
      if (courseId != null) 'course': courseId,
      'content': content,
      'createdAt': sentAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  String get senderName => sender?['name'] ?? 'Utilisateur';
  String get recipientName => recipient?['name'] ?? 'Utilisateur';
  
  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(sentAt.year, sentAt.month, sentAt.day);

    if (messageDate == today) {
      return '${sentAt.hour.toString().padLeft(2, '0')}:${sentAt.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hier';
    } else {
      return '${sentAt.day}/${sentAt.month}/${sentAt.year}';
    }
  }
}

class ConversationModel {
  final String userId;
  final String name;
  final String email;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      userId: json['userId'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null 
          ? DateTime.parse(json['lastMessageTime'])
          : DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(lastMessageTime.year, lastMessageTime.month, lastMessageTime.day);

    if (messageDate == today) {
      return '${lastMessageTime.hour.toString().padLeft(2, '0')}:${lastMessageTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hier';
    } else {
      return '${lastMessageTime.day}/${lastMessageTime.month}';
    }
  }
}
