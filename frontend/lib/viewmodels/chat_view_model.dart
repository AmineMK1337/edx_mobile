import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class ChatViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  List<UserModel> _professors = [];
  bool _isLoading = false;
  bool _isLoadingMessages = false;
  String? _errorMessage;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  List<UserModel> get professors => _professors;
  bool get isLoading => _isLoading;
  bool get isLoadingMessages => _isLoadingMessages;
  String? get errorMessage => _errorMessage;

  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<void> loadChats() async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/chats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _chats = data.map((json) => ChatModel.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading chats: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProfessors() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/professors'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _professors = (data['users'] as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Failed to load professors');
      }
    } catch (e) {
      print('Error loading professors: $e');
    }
  }

  Future<void> createChat(String professorId) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/admin/chats/$professorId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final chatData = json.decode(response.body);
        final newChat = ChatModel.fromJson(chatData);
        
        // Add to chats list if not already exists
        final existingIndex = _chats.indexWhere((c) => c.id == newChat.id);
        if (existingIndex == -1) {
          _chats.insert(0, newChat);
        }
        
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Failed to create chat');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error creating chat: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadChatMessages(String chatId) async {
    _setLoadingMessages(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/chats/$chatId/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _messages = data.map((json) => MessageModel.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading messages: $e');
    } finally {
      _setLoadingMessages(false);
    }
  }

  Future<void> sendMessage(String chatId, String content) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      // Add message optimistically to UI
      final tempMessage = MessageModel(
        sender: UserModel(
          id: 'temp',
          name: 'You',
          email: '',
          role: 'admin',
          isActive: true,
          createdAt: DateTime.now(),
        ),
        content: content,
        messageType: 'text',
        timestamp: DateTime.now(),
        readBy: [],
      );
      
      _messages.add(tempMessage);
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/admin/chats/$chatId/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': content,
          'messageType': 'text',
        }),
      );

      if (response.statusCode == 200) {
        // Remove temp message and add real one
        _messages.removeLast();
        final messageData = json.decode(response.body);
        final realMessage = MessageModel.fromJson(messageData);
        _messages.add(realMessage);
        
        // Update chat's last message
        final chatIndex = _chats.indexWhere((c) => c.id == chatId);
        if (chatIndex != -1) {
          _chats[chatIndex] = ChatModel(
            id: _chats[chatIndex].id,
            participants: _chats[chatIndex].participants,
            chatType: _chats[chatIndex].chatType,
            messages: _chats[chatIndex].messages,
            lastMessage: realMessage,
            unreadCount: _chats[chatIndex].unreadCount,
            createdAt: _chats[chatIndex].createdAt,
            updatedAt: DateTime.now(),
          );
        }
        
        _errorMessage = null;
        notifyListeners();
      } else {
        // Remove temp message on failure
        _messages.removeLast();
        notifyListeners();
        throw Exception('Failed to send message');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error sending message: $e');
      rethrow;
    }
  }

  Future<void> markMessageAsRead(String chatId, String messageId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      await http.put(
        Uri.parse('$baseUrl/admin/chats/$chatId/messages/$messageId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMessages(bool loading) {
    _isLoadingMessages = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
