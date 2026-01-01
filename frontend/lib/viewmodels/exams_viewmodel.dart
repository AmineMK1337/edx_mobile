import 'package:flutter/material.dart';
import 'package:my_app/models/exam_model.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/services/api_service.dart';

class ExamsViewModel extends ChangeNotifier {
  List<ExamModel> exams = [];
  bool isLoading = false;
  String? error;

  ExamsViewModel() {
    fetchExams();
  }

  Future<void> fetchExams() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/exams');
      
      if (response is List) {
        exams = response.map((data) {
          return ExamModel(
            title: data['title'] ?? '',
            subject: data['subject'] ?? '',
            status: data['status'] == 'passe' ? ExamStatus.passe : ExamStatus.planifie,
            date: data['date'] ?? '',
            time: data['time'] ?? '',
            className: data['className'] ?? '',
            studentCount: data['studentCount'] ?? 0,
            duration: data['duration'] ?? '',
            location: data['location'] ?? '',
          );
        }).toList();
      }
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Helper to get status properties based on enum
  Map<String, dynamic> getStatusProps(ExamStatus status) {
    if (status == ExamStatus.planifie) {
      return {
        "text": "Planifié",
        "bg": AppColors.statusPlanifieBg,
        "textColor": AppColors.statusPlanifieText,
      };
    } else {
      return {
        "text": "Passé",
        "bg": AppColors.statusPasseBg,
        "textColor": AppColors.statusPasseText,
      };
    }
  }
}

