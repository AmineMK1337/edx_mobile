import 'package:flutter/material.dart';
import '../models/absence_e_model.dart';
import '../services/api_service.dart';

class AbsenceViewModel extends ChangeNotifier {
  List<Absence> _absencesList = [];
  bool _isLoading = true;

  List<Absence> get absencesList => _absencesList;
  bool get isLoading => _isLoading;

  // Getters pour les statistiques
  int get totalAbsences => _absencesList.length;
  int get unjustifiedCount => _absencesList.where((a) => !a.isJustified).length;

  Future<void> fetchAbsences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/absences', requiresAuth: true);
      
      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _absencesList = data.map((json) => Absence.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur AbsenceViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}