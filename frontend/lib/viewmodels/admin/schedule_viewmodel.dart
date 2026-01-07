import 'package:flutter/material.dart';
import '../../models/admin/schedule_model.dart';
import '../../services/api_service.dart';

class AdminScheduleViewModel extends ChangeNotifier {
  List<ScheduleClass> _classes = [];
  List<ProfessorAvailability> _professors = [];
  bool _isLoading = false;
  int _selectedTabIndex = 0;

  List<ScheduleClass> get classes => _classes;
  List<ProfessorAvailability> get professors => _professors;
  bool get isLoading => _isLoading;
  int get selectedTabIndex => _selectedTabIndex;

  AdminScheduleViewModel() {
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final classesResponse = await ApiService.get('/admin/schedules/classes');
      final profsResponse = await ApiService.get('/admin/schedules/professors');

      if (classesResponse != null && classesResponse is List) {
        _classes = classesResponse.map((json) => ScheduleClass.fromJson(json)).toList();
      }
      if (profsResponse != null && profsResponse is List) {
        _professors = profsResponse.map((json) => ProfessorAvailability.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _classes = [
        ScheduleClass(id: '1', title: 'INDP1A', subtitle: 'Première année - Groupe A', status: 'publié'),
        ScheduleClass(id: '2', title: 'INDP1B', subtitle: 'Première année - Groupe B', status: 'publié'),
        ScheduleClass(id: '3', title: 'INDP1C', subtitle: 'Première année - Groupe C', status: 'publié'),
        ScheduleClass(id: '4', title: 'INDP2A', subtitle: 'Deuxième année - Groupe A', status: 'publié'),
        ScheduleClass(id: '5', title: 'INDP2B', subtitle: 'Deuxième année - Groupe B', status: 'brouillon'),
        ScheduleClass(id: '6', title: 'INDP3A', subtitle: 'Troisième année - Groupe A', status: 'publié'),
      ];
      _professors = [
        ProfessorAvailability(name: 'Dr. Ben Salah', status: 'complet', hoursPerWeek: 18, coursesCount: 6),
        ProfessorAvailability(name: 'Dr. Trabelsi', status: 'disponible', hoursPerWeek: 12, coursesCount: 4),
        ProfessorAvailability(name: 'Dr. Gharbi', status: 'complet', hoursPerWeek: 16, coursesCount: 5),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<bool> publishSchedule(String classId) async {
    try {
      final response = await ApiService.put('/admin/schedules/classes/$classId/publish', {});
      if (response != null) {
        await fetchData();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> addSchedule(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/admin/schedules', data);
      if (response != null) {
        await fetchData();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
