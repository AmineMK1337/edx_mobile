import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import '../services/api_service.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsModel _settings = SettingsModel(
    userName: "",
    userPhone: "",
    pushNotifications: true,
    gradeAlerts: true,
    messageAlerts: true,
    absenceAlerts: false,
    isDarkMode: false,
    currentLanguage: "Français",
    passwordLastChanged: "",
  );
  bool _isLoading = false;
  String? _error;

  SettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSettings(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/settings/$userId');
      _settings = SettingsModel.fromJson(response);
    } catch (e) {
      debugPrint("Error loading settings: $e");
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _updateSettingsOnServer(String userId) async {
    try {
      await ApiService.put('/settings/$userId', {
        'pushNotifications': _settings.pushNotifications,
        'gradeAlerts': _settings.gradeAlerts,
        'messageAlerts': _settings.messageAlerts,
        'absenceAlerts': _settings.absenceAlerts,
        'isDarkMode': _settings.isDarkMode,
        'language': _settings.currentLanguage,
      });
    } catch (e) {
      debugPrint("Error updating settings: $e");
    }
  }

  void updatePushNotifications(bool value, {String? userId}) {
    _settings = _settings.copyWith(pushNotifications: value);
    notifyListeners();
    if (userId != null) _updateSettingsOnServer(userId);
  }

  void updateGradeAlerts(bool value, {String? userId}) {
    _settings = _settings.copyWith(gradeAlerts: value);
    notifyListeners();
    if (userId != null) _updateSettingsOnServer(userId);
  }

  void updateMessageAlerts(bool value, {String? userId}) {
    _settings = _settings.copyWith(messageAlerts: value);
    notifyListeners();
    if (userId != null) _updateSettingsOnServer(userId);
  }

  void updateAbsenceAlerts(bool value, {String? userId}) {
    _settings = _settings.copyWith(absenceAlerts: value);
    notifyListeners();
    if (userId != null) _updateSettingsOnServer(userId);
  }

  void updateDarkMode(bool value, {String? userId}) {
    _settings = _settings.copyWith(isDarkMode: value);
    notifyListeners();
    if (userId != null) _updateSettingsOnServer(userId);
  }

  void updateLanguage(String language, {String? userId}) {
    _settings = _settings.copyWith(currentLanguage: language);
    notifyListeners();
    if (userId != null) _updateSettingsOnServer(userId);
  }

  void logout() {
    ApiService.logout();
    debugPrint("User logged out");
  }
}
