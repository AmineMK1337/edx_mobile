import 'package:flutter/foundation.dart';
import '../../models/student/course_e_model.dart';
import '../../services/api_service.dart';

class EmploiViewModel extends ChangeNotifier {
  List<Course> _coursesList = [];
  bool _isLoading = true;

  List<Course> get coursesList => _coursesList;
  bool get isLoading => _isLoading;

  final List<String> weekDays = [
    "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"
  ];

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/courses', requiresAuth: true);

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _coursesList = data.map((json) => Course.fromJson(json)).toList();
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