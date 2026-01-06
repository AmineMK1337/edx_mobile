import 'package:flutter/material.dart';
import '../../models/professor/student_model.dart';
import '../../services/api_service.dart';

class AbsenceMarkingViewModel extends ChangeNotifier {
  List<StudentModel> students = [];
  bool isLoading = false;
  String? error;
  bool isSubmitting = false;

  AbsenceMarkingViewModel() {
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/users/students', requiresAuth: true);

      if (response is List) {
        students = response
            .whereType<Map>()
            .map((data) => StudentModel.fromJson(Map<String, dynamic>.from(data)))
            .take(30)
            .toList();
      } else if (response is Map && response['data'] is List) {
        students = (response['data'] as List)
            .whereType<Map>()
            .map((data) => StudentModel.fromJson(Map<String, dynamic>.from(data)))
            .take(30)
            .toList();
      } else {
        students = [];
      }
    } catch (e) {
      error = 'Impossible de charger les étudiants: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateStudentStatus(int index, StudentAttendanceStatus status) {
    if (index >= 0 && index < students.length) {
      students[index].status = status;
      notifyListeners();
    }
  }

  Future<void> submitAbsences(String subject, String sessionType, String className) async {
    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      final attendanceData = {
        'students': students.map((s) => {
          'studentId': s.id,
          'status': _statusToString(s.status),
        }).toList(),
        'subject': subject,
        'sessionType': sessionType,
        'className': className,
        'date': DateTime.now().toIso8601String(),
      };

      final response = await ApiService.post('/attendance/mark', attendanceData, requiresAuth: true);
      error = null;
      
      // Success - you can add a success message or callback here
      print('Absences enregistrées avec succès: ${response}');
    } catch (e) {
      error = 'Erreur lors de l\'enregistrement: $e';
      print('Error submitting absences: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  String _statusToString(StudentAttendanceStatus status) {
    switch (status) {
      case StudentAttendanceStatus.present:
        return 'present';
      case StudentAttendanceStatus.late:
        return 'late';
      case StudentAttendanceStatus.justified:
        return 'justified';
      default:
        return 'absent';
    }
  }
}
