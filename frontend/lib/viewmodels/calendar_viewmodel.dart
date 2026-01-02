import 'package:flutter/material.dart';
import '../models/calendar_event_model.dart';
import '../core/constants/app_colors.dart';
import '../services/api_service.dart';

class CalendarViewModel extends ChangeNotifier {
  List<CalendarEventModel> events = [];
  bool isLoading = false;
  String? error;

  CalendarViewModel() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/events', requiresAuth: true);
      
      if (response is List) {
        events = response.map((data) => CalendarEventModel.fromJson(Map<String, dynamic>.from(data))).toList();
      } else if (response is Map && response['data'] is List) {
        events = (response['data'] as List)
            .map((data) => CalendarEventModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        events = [];
      }
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Helper pour obtenir le style du badge selon le type
  Map<String, dynamic> getEventTypeStyle(EventType type) {
    switch (type) {
      case EventType.exam:
        return {'label': 'Examen', 'bg': AppColors.tagExamBg, 'text': AppColors.tagExamText};
      case EventType.meeting:
        return {'label': 'Réunion', 'bg': AppColors.tagMeetingBg, 'text': AppColors.tagMeetingText};
      case EventType.tp:
        return {'label': 'TP', 'bg': AppColors.tagTpBg, 'text': AppColors.tagTpText};
      case EventType.td:
        return {'label': 'TD', 'bg': AppColors.tagTpBg, 'text': AppColors.tagTpText};
      case EventType.course:
        return {'label': 'Cours', 'bg': AppColors.tagExamBg, 'text': AppColors.tagExamText};
      case EventType.holiday:
        return {'label': 'Vacances', 'bg': AppColors.tagPersoBg, 'text': AppColors.tagPersoText};
      case EventType.personal:
        return {'label': 'Personnel', 'bg': AppColors.tagPersoBg, 'text': AppColors.tagPersoText};
    }
  }
}