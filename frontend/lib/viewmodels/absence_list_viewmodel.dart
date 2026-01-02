import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class AbsenceListViewModel extends ChangeNotifier {
  List<StudentModel> students = [];
  bool isLoading = false;
  String? error;

  final String subject;
  final String sessionType;
  final String className;

  AbsenceListViewModel(this.subject, this.sessionType, this.className) {
    fetchAbsenceList();
  }

  Future<void> fetchAbsenceList() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Fetch attendance records for this specific class/subject/session
      final response = await ApiService.get('/attendance/class/$className');

      if (response is List) {
        students = response
            .whereType<Map>()
            .map((data) => _parseStudentFromAttendance(Map<String, dynamic>.from(data)))
            .toList();
      } else if (response is Map && response['data'] is List) {
        students = (response['data'] as List)
            .whereType<Map>()
            .map((data) => _parseStudentFromAttendance(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        students = [];
      }
    } catch (e) {
      error = 'Impossible de charger les absences: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  StudentModel _parseStudentFromAttendance(Map<String, dynamic> json) {
    final statusStr = json['statusDetail'] ?? json['status'] ?? 'absent';
    final status = _parseStatus(statusStr);

    return StudentModel(
      id: json['student']?['_id'] ?? json['student'] ?? 'unknown',
      name: json['student']?['name'] ?? 'Étudiant inconnu',
      email: json['student']?['email'] ?? '',
      matricule: json['student']?['matricule'] ?? 'N/A',
      status: status,
    );
  }

  StudentAttendanceStatus _parseStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'present':
        return StudentAttendanceStatus.present;
      case 'absent':
        return StudentAttendanceStatus.absent;
      case 'late':
      case 'retard':
        return StudentAttendanceStatus.late;
      case 'justified':
        return StudentAttendanceStatus.justified;
      default:
        return StudentAttendanceStatus.absent;
    }
  }
}
