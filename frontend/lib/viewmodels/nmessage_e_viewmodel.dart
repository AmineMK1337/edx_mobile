import 'package:flutter/foundation.dart';
import '../models/message_request_e_model.dart';
import '../services/api_service.dart';

class NMessageViewModel extends ChangeNotifier {
  String? _selectedRole = 'Professeur';
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get selectedRole => _selectedRole;
  final List<String> roles = ['Professeur', 'Administrateur'];

  void setSelectedRole(String? role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<bool> sendMessage(MessageRequest request) async {
    if (request.subject.isEmpty || request.content.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/messages', {
        'role': request.role,
        'specificName': request.specificName,
        'content': request.content,
      }, requiresAuth: true);

      return response != null;
    } catch (e) {
      debugPrint("Erreur NMessageViewModel : $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}