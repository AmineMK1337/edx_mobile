import 'package:flutter/material.dart';
import '../../models/admin/subject_model.dart';
import '../../services/api_service.dart';

class AdminSubjectViewModel extends ChangeNotifier {
  List<AdminSubject> _subjects = [];
  List<AdminSubject> _filteredSubjects = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<AdminSubject> get subjects => _filteredSubjects.isEmpty && _searchQuery.isEmpty ? _subjects : _filteredSubjects;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  AdminSubjectViewModel() {
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/subjects');
      if (response != null && response is List) {
        _subjects = response.map((json) => AdminSubject.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _subjects = [
        AdminSubject(id: '1', name: 'Réseaux Informatiques', code: 'RT301', professor: 'Dr. Ben Salah', coeff: 3.0, semester: 1, type: 'Cours'),
        AdminSubject(id: '2', name: 'Programmation C++', code: 'INFO201', professor: 'Dr. Trabelsi', coeff: 2.5, semester: 1, type: 'TD'),
        AdminSubject(id: '3', name: 'Électronique', code: 'ELEC101', professor: 'Dr. Gharbi', coeff: 2.0, semester: 2, type: 'TP'),
        AdminSubject(id: '4', name: 'Mathématiques', code: 'MATH101', professor: 'Dr. Sassi', coeff: 3.5, semester: 1, type: 'Cours'),
      ];
    }

    _filteredSubjects = List.from(_subjects);
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredSubjects = List.from(_subjects);
    } else {
      _filteredSubjects = _subjects.where((s) =>
          s.name.toLowerCase().contains(query.toLowerCase()) ||
          s.code.toLowerCase().contains(query.toLowerCase()) ||
          s.professor.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  Future<bool> addSubject(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/admin/subjects', data);
      if (response != null) {
        await fetchSubjects();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> updateSubject(String id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('/admin/subjects/$id', data);
      if (response != null) {
        await fetchSubjects();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> deleteSubject(String id) async {
    try {
      final response = await ApiService.delete('/admin/subjects/$id');
      if (response != null) {
        await fetchSubjects();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
