import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/course_e_model.dart';

class EmploiViewModel extends ChangeNotifier {
  List<Course> _coursesList = [];
  bool _isLoading = true;

  List<Course> get coursesList => _coursesList;
  bool get isLoading => _isLoading;

  final List<String> weekDays = [
    "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"
  ];

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/courses'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _coursesList = data.map((json) => Course.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Erreur EmploiViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper pour filtrer les cours par jour
  List<Course> getCoursesForDay(String dayName) {
    return _coursesList
        .where((c) => c.day.toLowerCase() == dayName.toLowerCase())
        .toList();
  }
}