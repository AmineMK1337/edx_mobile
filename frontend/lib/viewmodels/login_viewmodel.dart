import 'package:flutter/material.dart';
import 'package:my_app/services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? user;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      user = response['user'];
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    user = null;
    error = null;
    notifyListeners();
  }
}
