import 'package:flutter/material.dart';
import 'package:my_app/models/exam_model.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/services/api_service.dart';

class ExamsViewModel extends ChangeNotifier {
  List<ExamModel> exams = [];
  bool isLoading = false;
  bool isSubmitting = false;
  String? error;

  ExamsViewModel() {
    if (ApiService.getToken() != null) {
      fetchExams();
    }
  }

  Future<void> fetchExams() async {
    if (ApiService.getToken() == null) return;
    
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/exams', requiresAuth: true);

      if (response is List) {
        exams = response
            .whereType<Map>()
            .map((data) => ExamModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        exams = [];
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExam(ExamModel exam) async {
    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/exams', exam.toJson(), requiresAuth: true);
      ExamModel createdExam;

      if (response is Map<String, dynamic>) {
        createdExam = ExamModel.fromJson(Map<String, dynamic>.from(response));
      } else if (response is Map) {
        createdExam = ExamModel.fromJson(Map<String, dynamic>.from(response));
      } else {
        createdExam = exam;
      }

      exams.insert(0, createdExam);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> updateExam(ExamModel exam) async {
    if (exam.id == null || exam.id!.isEmpty) {
      throw Exception('Identifiant manquant pour la mise à jour');
    }

    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.put('/exams/${exam.id}', exam.toJson(), requiresAuth: true);
      ExamModel updatedExam;

      if (response is Map<String, dynamic>) {
        updatedExam = ExamModel.fromJson(Map<String, dynamic>.from(response));
      } else if (response is Map) {
        updatedExam = ExamModel.fromJson(Map<String, dynamic>.from(response));
      } else {
        updatedExam = exam;
      }

      exams = exams.map((e) => e.id == updatedExam.id ? updatedExam : e).toList();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // Helper to get status properties based on enum
  Map<String, dynamic> getStatusProps(ExamStatus status) {
    return statusPropsFor(status);
  }

  static Map<String, dynamic> statusPropsFor(ExamStatus status) {
    switch (status) {
      case ExamStatus.scheduled:
        return {
          'text': 'Planifié',
          'bg': AppColors.statusPlanifieBg,
          'textColor': AppColors.statusPlanifieText,
        };
      case ExamStatus.completed:
        return {
          'text': 'Passé',
          'bg': AppColors.statusPasseBg,
          'textColor': AppColors.statusPasseText,
        };
      case ExamStatus.cancelled:
        return {
          'text': 'Annulé',
          'bg': AppColors.statusPasseBg,
          'textColor': AppColors.statusPasseText,
        };
    }
  }
}

