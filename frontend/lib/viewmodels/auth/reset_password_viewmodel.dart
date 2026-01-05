import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../views/auth/reset_password_step2.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyOtp(BuildContext context, String email) async {
    final code = otpController.text.trim();

    debugPrint('🔍 verifyOtp called with email: "$email"');
    debugPrint('🔍 Code: "$code"');

    if (code.isEmpty) {
      errorMessage = "Veuillez entrer le code";
      notifyListeners();
      return;
    }

    if (code.length < 4) {
      errorMessage = "Le code doit contenir au moins 4 caractères";
      notifyListeners();
      return;
    }

    if (email.isEmpty) {
      errorMessage = "Email manquant";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.verifyResetCode(email, code);

      if (response['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordStep2View(
              email: email,
              code: code,
            ),
          ),
        );
      } else {
        errorMessage = response['message'] ?? "Code invalide ou expiré";
      }
    } catch (e) {
      errorMessage = "Erreur lors de la vérification: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
