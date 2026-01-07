import 'package:flutter/material.dart';
import '../../models/admin/publish_model.dart';
import '../../services/api_service.dart';

class AdminPublishViewModel extends ChangeNotifier {
  List<ExamSession> _examSessions = [];
  List<ExamSession> _selectedSessions = [];
  bool _isLoading = false;
  int _currentStep = 0;

  List<ExamSession> get examSessions => _examSessions;
  List<ExamSession> get selectedSessions => _selectedSessions;
  bool get isLoading => _isLoading;
  int get currentStep => _currentStep;

  AdminPublishViewModel() {
    fetchExamSessions();
  }

  Future<void> fetchExamSessions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/publish/sessions');
      if (response != null && response is List) {
        _examSessions = response.map((json) => ExamSession.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _examSessions = [
        ExamSession(id: '1', subject: 'Réseaux Informatiques', type: 'DS', group: '2A-RT-G1', professor: 'Dr. Ben Salah', date: '2024-01-20', studentCount: 25, isReady: true),
        ExamSession(id: '2', subject: 'Programmation C++', type: 'Examen', group: '2A-TIC-G1', professor: 'Dr. Trabelsi', date: '2024-01-21', studentCount: 30, isReady: true),
        ExamSession(id: '3', subject: 'Électronique', type: 'TP', group: '1A-G2', professor: 'Dr. Gharbi', date: '2024-01-22', studentCount: 20, isReady: false),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleSessionSelection(ExamSession session) {
    if (_selectedSessions.contains(session)) {
      _selectedSessions.remove(session);
    } else {
      _selectedSessions.add(session);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedSessions = List.from(_examSessions.where((s) => s.isReady));
    notifyListeners();
  }

  void clearSelection() {
    _selectedSessions.clear();
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void resetSteps() {
    _currentStep = 0;
    _selectedSessions.clear();
    notifyListeners();
  }

  Future<bool> publishGrades(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/admin/publish/grades', data);
      if (response != null) {
        resetSteps();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
