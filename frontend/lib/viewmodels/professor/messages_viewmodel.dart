import 'package:flutter/material.dart';
import '../../models/professor/message_model.dart';
import '../../services/api_service.dart';

class UserRecipient {
  final String id;
  final String name;
  final String email;
  final String role;

  UserRecipient({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserRecipient.fromJson(Map<String, dynamic> json) {
    return UserRecipient(
      id: json['_id'] ?? '',
      name: json['name'] ?? json['email'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class MessagesViewModel extends ChangeNotifier {
  List<ConversationModel> conversations = [];
  List<MessageModel> currentMessages = [];
  List<MessageModel> allMessages = [];
  List<UserRecipient> availableRecipients = [];
  bool isLoading = false;
  bool isLoadingRecipients = false;
  bool isLoadingAllMessages = false;
  String? error;
  String? currentRecipientId;
  String messageFilter = 'all'; // 'all', 'sent', 'received'

  MessagesViewModel() {
    if (ApiService.getToken() != null) {
      fetchConversations();
      fetchAllMessages();
    }
  }

  Future<void> fetchAllMessages({String? filter}) async {
    if (ApiService.getToken() == null) return;

    isLoadingAllMessages = true;
    notifyListeners();

    try {
      final queryFilter = filter ?? messageFilter;
      final response = await ApiService.get('/messages/all?filter=$queryFilter', requiresAuth: true);

      if (response is List) {
        allMessages = response
            .whereType<Map>()
            .map((data) => MessageModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        allMessages = [];
      }
    } catch (e) {
      print('Error fetching all messages: $e');
    } finally {
      isLoadingAllMessages = false;
      notifyListeners();
    }
  }

  void setMessageFilter(String filter) {
    messageFilter = filter;
    fetchAllMessages(filter: filter);
  }

  Future<void> fetchAvailableRecipients() async {
    if (ApiService.getToken() == null) return;

    isLoadingRecipients = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/users', requiresAuth: true);
      
      if (response is List) {
        availableRecipients = response
            .whereType<Map>()
            .map((data) => UserRecipient.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else if (response is Map && response['data'] is List) {
        availableRecipients = (response['data'] as List)
            .whereType<Map>()
            .map((data) => UserRecipient.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        availableRecipients = [];
      }
    } catch (e) {
      print('Error fetching recipients: $e');
    } finally {
      isLoadingRecipients = false;
      notifyListeners();
    }
  }

  Future<bool> createNewConversation(String recipientId, String content) async {
    if (ApiService.getToken() == null) return false;

    try {
      final response = await ApiService.post(
        '/messages',
        {
          'recipientId': recipientId,
          'content': content,
        },
        requiresAuth: true,
      );

      if (response != null) {
        await fetchConversations();
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating conversation: $e');
      error = 'Erreur lors de l\'envoi: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchConversations() async {
    if (ApiService.getToken() == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      print('Fetching conversations');
      final response = await ApiService.get('/messages/conversations', requiresAuth: true);

      if (response is List) {
        conversations = response
            .whereType<Map>()
            .map((data) => ConversationModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        conversations = [];
      }
      error = null;
    } catch (e) {
      print('Error fetching conversations: $e');
      error = 'Impossible de charger les conversations: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConversation(String recipientId) async {
    if (ApiService.getToken() == null) return;

    currentRecipientId = recipientId;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      print('Fetching conversation with: $recipientId');
      final response = await ApiService.get('/messages/conversation/$recipientId', requiresAuth: true);

      if (response is List) {
        currentMessages = response
            .whereType<Map>()
            .map((data) => MessageModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        currentMessages = [];
      }
      error = null;
    } catch (e) {
      print('Error fetching conversation: $e');
      error = 'Impossible de charger la conversation: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String recipientId, String content) async {
    if (ApiService.getToken() == null) return;

    try {
      print('Sending message to: $recipientId');
      final response = await ApiService.post(
        '/messages',
        {
          'recipientId': recipientId,
          'content': content,
        },
        requiresAuth: true,
      );

      if (response is Map) {
        final newMessage = MessageModel.fromJson(Map<String, dynamic>.from(response));
        currentMessages.add(newMessage);
        notifyListeners();
        
        // Refresh conversations to update the list
        await fetchConversations();
      }
    } catch (e) {
      print('Error sending message: $e');
      error = 'Erreur lors de l\'envoi: $e';
      notifyListeners();
    }
  }

  Future<void> deleteMessage(String messageId) async {
    if (ApiService.getToken() == null) return;

    try {
      await ApiService.delete('/messages/$messageId', requiresAuth: true);
      currentMessages.removeWhere((msg) => msg.id == messageId);
      notifyListeners();
    } catch (e) {
      print('Error deleting message: $e');
      error = 'Erreur lors de la suppression: $e';
      notifyListeners();
    }
  }
}
