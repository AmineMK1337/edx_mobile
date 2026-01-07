import 'package:flutter/material.dart';
import '../../models/admin/rattrapage_model.dart';
import '../../services/api_service.dart';

class AdminRattrapageViewModel extends ChangeNotifier {
  List<RattrapageSession> _sessions = [];
  bool _isLoading = false;
  String _selectedFilter = 'upcoming';

  List<RattrapageSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;

  AdminRattrapageViewModel() {
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/rattrapages');
      if (response != null && response is List) {
        _sessions = response.map((json) => RattrapageSession.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _sessions = [
        RattrapageSession(id: '1', subject: 'Réseaux Informatiques', professor: 'Dr. Ben Salah', date: '2024-02-15', time: '09:00 - 11:00', room: 'Amphi A', registered: 25, capacity: 50),
        RattrapageSession(id: '2', subject: 'Programmation C++', professor: 'Dr. Trabelsi', date: '2024-02-16', time: '14:00 - 16:00', room: 'Salle TD1', registered: 18, capacity: 30),
        RattrapageSession(id: '3', subject: 'Électronique', professor: 'Dr. Gharbi', date: '2024-02-17', time: '10:00 - 12:00', room: 'Labo 1', registered: 12, capacity: 20),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<bool> createSession(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/admin/rattrapages', data);
      if (response != null) {
        await fetchSessions();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> updateSession(String id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('/admin/rattrapages/$id', data);
      if (response != null) {
        await fetchSessions();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> deleteSession(String id) async {
    try {
      final response = await ApiService.delete('/admin/rattrapages/$id');
      if (response != null) {
        await fetchSessions();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  RattrapageSession? getSessionById(String id) {
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
