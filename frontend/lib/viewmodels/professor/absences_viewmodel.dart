import 'package:flutter/material.dart';
import '../../models/professor/absence_model.dart';
import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class AbsencesViewModel extends ChangeNotifier {
  List<AbsenceModel> absences = [];
  bool isLoading = false;
  String? error;

  AbsencesViewModel() {
    if (ApiService.getToken() != null) {
      fetchAbsences();
    }
  }

  Future<void> fetchAbsences() async {
    if (ApiService.getToken() == null) return;
    
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/absences', requiresAuth: true);

      if (response is List) {
        absences = response
            .whereType<Map>()
            .map((data) => AbsenceModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else if (response is Map && response['data'] is List) {
        absences = (response['data'] as List)
            .whereType<Map>()
            .map((data) => AbsenceModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        absences = [];
      }
      error = null;
    } catch (e) {
      error = 'Impossible de charger les absences: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Helper pour obtenir les propriétés de style selon le statut
  Map<String, dynamic> getStatusProps(AbsenceStatus status) {
    switch (status) {
      case AbsenceStatus.present:
        return {
          "text": "Présent",
          "bg": AppColors.statusSaisieBg,
          "textColor": AppColors.statusSaisieText,
          "icon": Icons.check,
          "iconColor": Colors.green,
          "iconBg": AppColors.iconBgGreen,
        };
      case AbsenceStatus.late:
        return {
          "text": "En retard",
          "bg": Colors.orange.withOpacity(0.1),
          "textColor": Colors.orange,
          "icon": Icons.watch_later,
          "iconColor": Colors.orange,
          "iconBg": Colors.orange.withOpacity(0.2),
        };
      case AbsenceStatus.justified:
        return {
          "text": "Justifié",
          "bg": Colors.blue.withOpacity(0.1),
          "textColor": Colors.blue,
          "icon": Icons.verified,
          "iconColor": Colors.blue,
          "iconBg": Colors.blue.withOpacity(0.2),
        };
      default: // absent
        return {
          "text": "Absent",
          "bg": AppColors.statusASaisirBg,
          "textColor": AppColors.statusASaisirText,
          "icon": Icons.close,
          "iconColor": Colors.red,
          "iconBg": AppColors.iconBgRed,
        };
    }
  }
}
