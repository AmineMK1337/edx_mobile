import 'package:flutter/material.dart';
import '../../models/student/message_e_model.dart';
import '../../services/api_service.dart';

class MessagesViewModel extends ChangeNotifier {
  List<AppMessage> _messagesList = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<AppMessage> get messagesList => _messagesList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMessages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint("🔥 Fetching conversations...");
      final response = await ApiService.get('/messages/conversations', requiresAuth: true);
      
      debugPrint("🔥 Response received: $response");

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      } else if (response is Map) {
        // Si la réponse est un map mais sans 'data', essayer de l'utiliser directement
        data = [response];
      }
      
      debugPrint("🔥 Data to process: $data");
      
      _messagesList = data.map((json) => AppMessage.fromJson(json)).toList();
      debugPrint("🔥 Conversations loaded: ${_messagesList.length}");
      
    } catch (e) {
      _errorMessage = "Erreur lors du chargement des conversations: $e";
      debugPrint("❌ Erreur MessagesViewModel : $e");
      _messagesList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
