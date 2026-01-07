import 'user_model.dart';

class ChatModel {
  final String id;
  final List<UserModel> participants;
  final String chatType;
  final List<MessageModel> messages;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.participants,
    required this.chatType,
    required this.messages,
    this.lastMessage,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participants: (json['participants'] as List? ?? [])
          .map((p) => UserModel.fromJson(p))
          .toList(),
      chatType: json['chatType'] ?? 'admin_professor',
      messages: (json['messages'] as List? ?? [])
          .map((m) => MessageModel.fromJson(m))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((p) => p.toJson()).toList(),
      'chatType': chatType,
      'messages': messages.map((m) => m.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class MessageModel {
  final String? id;
  final UserModel sender;
  final String content;
  final String messageType;
  final DateTime timestamp;
  final List<String> readBy;

  MessageModel({
    this.id,
    required this.sender,
    required this.content,
    required this.messageType,
    required this.timestamp,
    required this.readBy,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      sender: UserModel.fromJson(json['sender']),
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      readBy: List<String>.from(json['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'sender': sender.toJson(),
      'content': content,
      'messageType': messageType,
      'timestamp': timestamp.toIso8601String(),
      'readBy': readBy,
    };
  }
}
