import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/result_e_model.dart';

class ResultatsViewModel extends ChangeNotifier {
  List<ResultModel> _resultsList = [];
  bool _isLoading = true;
  double _generalAverage = 0.0;

  // Getters
  List<ResultModel> get resultsList => _resultsList;
  bool get isLoading => _isLoading;
  double get generalAverage => _generalAverage;

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchResults() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/results'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _resultsList = data.map((json) => ResultModel.fromJson(json)).toList();
        _calculateGeneralAverage();
      }
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