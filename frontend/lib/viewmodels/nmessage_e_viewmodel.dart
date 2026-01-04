import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/message_request_e_model.dart';

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
      const String serverIP = "192.168.100.17";
      final baseUrl = kIsWeb ? 'http://localhost:5000' : 'http://$serverIP:5000';
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/messagees/envoyer'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Erreur NMessageViewModel : $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}