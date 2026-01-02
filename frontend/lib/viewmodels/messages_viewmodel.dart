import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class MessagesViewModel extends ChangeNotifier {
  List<ConversationModel> conversations = [];
  List<MessageModel> currentMessages = [];
  bool isLoading = false;
  String? error;
  String? currentRecipientId;

  MessagesViewModel() {
    if (ApiService.getToken() != null) {
      fetchConversations();
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
