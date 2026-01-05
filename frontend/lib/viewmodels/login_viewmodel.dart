import 'package:flutter/material.dart';

import '../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  int selectedRole = 0;
  bool isLoading = false;

  final identifiantController = TextEditingController();
  final passwordController = TextEditingController();

  void selectRole(int index) {
    selectedRole = index;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login() async {
    final email = identifiantController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Veuillez remplir tous les champs');
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.login(email, password);
      return result;
    } catch (e) {
      // Re-throw with a cleaner message
      String errorMsg = e.toString();
      if (errorMsg.contains('401') || 
          errorMsg.toLowerCase().contains('invalid') ||
          errorMsg.toLowerCase().contains('unauthorized')) {
        throw Exception('Email ou mot de passe incorrect');
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    identifiantController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
