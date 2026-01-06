import 'package:flutter/material.dart';
import '../../models/student/message_e_model.dart';
import '../../services/api_service.dart';

class MessagesViewModel extends ChangeNotifier {
  List<AppMessage> _messagesList = [];
  bool _isLoading = true;

  List<AppMessage> get messagesList => _messagesList;
  bool get isLoading => _isLoading;

  Future<void> fetchMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/messages/conversations', requiresAuth: true);

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _messagesList = data.map((json) => AppMessage.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur MessagesViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}