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
      final response = await ApiService.get('/events');
      
      if (response is List) {
        events = response.map((data) {
          return CalendarEventModel(
            title: data['title'] ?? '',
            type: _stringToEventType(data['type']),
            date: data['date'] ?? '',
            time: data['time'] ?? '',
            location: data['location'] ?? '',
            group: data['group'] ?? '',
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

  EventType _stringToEventType(String type) {
    switch (type) {
      case 'reunion':
        return EventType.reunion;
      case 'tp':
        return EventType.tp;
      case 'personnel':
        return EventType.personnel;
      case 'examen':
      default:
        return EventType.examen;
    }
  }

  // Helper pour obtenir le style du badge selon le type
  Map<String, dynamic> getEventTypeStyle(EventType type) {
    switch (type) {
      case EventType.examen:
        return {'label': 'Examen', 'bg': AppColors.tagExamBg, 'text': AppColors.tagExamText};
      case EventType.reunion:
        return {'label': 'Réunion', 'bg': AppColors.tagMeetingBg, 'text': AppColors.tagMeetingText};
      case EventType.tp:
        return {'label': 'TP', 'bg': AppColors.tagTpBg, 'text': AppColors.tagTpText};
      case EventType.personnel:
        return {'label': 'Personnel', 'bg': AppColors.tagPersoBg, 'text': AppColors.tagPersoText};
    }
  }
}

