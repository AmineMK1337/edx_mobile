import 'package:flutter/material.dart';
import '../../models/student/result_e_model.dart';
import '../../services/api_service.dart';

class ResultatsViewModel extends ChangeNotifier {
  List<ResultModel> _resultsList = [];
  bool _isLoading = true;
  double _generalAverage = 0.0;

  // Getters
  List<ResultModel> get resultsList => _resultsList;
  bool get isLoading => _isLoading;
  double get generalAverage => _generalAverage;

  Future<void> fetchResults() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/notes', requiresAuth: true);

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _resultsList = data.map((json) => ResultModel.fromJson(json)).toList();
      _calculateGeneralAverage();
    } catch (e) {
      debugPrint("Erreur ResultatsViewModel: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateGeneralAverage() {
    if (_resultsList.isEmpty) {
      _generalAverage = 0.0;
      return;
    }
    double totalPoints = 0;
    int totalCredits = 0;
    for (var result in _resultsList) {
      totalPoints += result.average * result.credits;
      totalCredits += result.credits;
    }
    _generalAverage = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }
}
