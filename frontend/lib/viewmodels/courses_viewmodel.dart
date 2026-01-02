import 'package:flutter/material.dart';
import 'package:my_app/models/course_model.dart';
import 'package:my_app/services/api_service.dart';

class CoursesViewModel extends ChangeNotifier {
  List<CourseModel> courses = [];
  bool isLoading = false;
  String? error;

  CoursesViewModel() {
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/courses', requiresAuth: true);

      if (response is List) {
        courses = response
            .whereType<Map>()
            .map((data) => CourseModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else if (response is Map && response['data'] is List) {
        courses = (response['data'] as List)
            .whereType<Map>()
            .map((data) => CourseModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        courses = [];
      }
      error = null;
    } catch (e) {
      error = 'Impossible de charger les cours: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
