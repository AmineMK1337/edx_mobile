import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ResetPasswordStep2ViewModel extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  Future<bool> resetPassword(String email, String code) async {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty) {
      errorMessage = "Veuillez entrer un nouveau mot de passe";
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      errorMessage = "Le mot de passe doit contenir au moins 6 caractères";
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      errorMessage = "Les mots de passe ne correspondent pas";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.resetPassword(email, code, password);

      if (response['success'] == true) {
        successMessage = "Mot de passe mis à jour avec succès !";
        notifyListeners();
        return true;
      } else {
        errorMessage = response['message'] ?? "Erreur lors de la réinitialisation";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Erreur: ${e.toString()}";
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
