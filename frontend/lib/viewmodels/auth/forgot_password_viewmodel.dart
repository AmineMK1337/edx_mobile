import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<String> submit() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      throw Exception("Veuillez entrer votre email");
    }

    if (!email.contains('@')) {
      throw Exception("Veuillez entrer un email valide");
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.forgotPassword(email);

      if (result["success"] != true) {
        throw Exception(result["message"]);
      }

      return "Code de réinitialisation envoyé à votre email";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
