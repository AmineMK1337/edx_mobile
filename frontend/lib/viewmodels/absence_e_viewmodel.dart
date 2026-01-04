import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/absence_e_model.dart';

class AbsenceViewModel extends ChangeNotifier {
  List<Absence> _absencesList = [];
  bool _isLoading = true;

  List<Absence> get absencesList => _absencesList;
  bool get isLoading => _isLoading;

  // Getters pour les statistiques
  int get totalAbsences => _absencesList.length;
  int get unjustifiedCount => _absencesList.where((a) => !a.isJustified).length;

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchAbsences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/absences'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _absencesList = data.map((json) => Absence.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Erreur AbsenceViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}