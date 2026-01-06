import 'package:flutter/material.dart';
import '../../models/professor/calendar_event_model.dart';
import '../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class CalendarViewModel extends ChangeNotifier {
  List<CalendarEventModel> events = [];
  List<CalendarEventModel> upcomingEvents = [];
  bool isLoading = false;
  String? error;

  CalendarViewModel() {
    if (ApiService.getToken() != null) {
      fetchAllEvents();
    }
  }

  Future<void> fetchAllEvents() async {
    if (ApiService.getToken() == null) return;
    
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      List<CalendarEventModel> allEvents = [];
      
      // Fetch calendar events
      try {
        final eventsResponse = await ApiService.get('/events', requiresAuth: true);
        if (eventsResponse is List) {
          allEvents.addAll(eventsResponse.map((data) => CalendarEventModel.fromJson(Map<String, dynamic>.from(data))));
        } else if (eventsResponse is Map && eventsResponse['data'] is List) {
          allEvents.addAll((eventsResponse['data'] as List)
              .map((data) => CalendarEventModel.fromJson(Map<String, dynamic>.from(data))));
        }
      } catch (e) {
        print('Error fetching events: $e');
      }
      
      // Fetch exams and convert to calendar events
      try {
        final examsResponse = await ApiService.get('/exams', requiresAuth: true);
        List examsList = [];
        if (examsResponse is List) {
          examsList = examsResponse;
        } else if (examsResponse is Map && examsResponse['data'] is List) {
          examsList = examsResponse['data'] as List;
        }
        
        for (var exam in examsList) {
          if (exam['date'] != null) {
            allEvents.add(CalendarEventModel(
              id: exam['_id'],
              title: exam['title'] ?? exam['course']?['title'] ?? 'Examen',
              type: EventType.exam,
              date: DateTime.parse(exam['date']),
              startTime: exam['startTime'] ?? exam['time'] ?? '08:00',
              endTime: exam['endTime'],
              location: exam['room'] ?? exam['location'] ?? 'Salle à déterminer',
              classId: exam['class'] is String ? exam['class'] : exam['class']?['_id'],
              courseId: exam['course'] is String ? exam['course'] : exam['course']?['_id'],
              description: exam['description'],
              classDetails: exam['class'] is Map ? exam['class'] : null,
              course: exam['course'] is Map ? exam['course'] : null,
            ));
          }
        }
      } catch (e) {
        print('Error fetching exams: $e');
      }
      
      // Add static holidays for 2026
      _addHolidays(allEvents);
      
      // Sort all events by date
      allEvents.sort((a, b) => a.date.compareTo(b.date));
      events = allEvents;
      
      // Filter upcoming events (today and future)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      upcomingEvents = allEvents
          .where((e) => e.date.isAfter(today.subtract(const Duration(days: 1))))
          .take(10)
          .toList();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void _addHolidays(List<CalendarEventModel> eventsList) {
    final now = DateTime.now();
    final year = now.year;
    
    // Tunisian/French academic holidays
    final holidays = [
      {'title': 'Nouvel An', 'date': DateTime(year, 1, 1)},
      {'title': 'Fête de la Révolution', 'date': DateTime(year, 1, 14)},
      {'title': 'Fête de l\'Indépendance', 'date': DateTime(year, 3, 20)},
      {'title': 'Fête des Martyrs', 'date': DateTime(year, 4, 9)},
      {'title': 'Fête du Travail', 'date': DateTime(year, 5, 1)},
      {'title': 'Fête de la République', 'date': DateTime(year, 7, 25)},
      {'title': 'Fête de la Femme', 'date': DateTime(year, 8, 13)},
      {'title': 'Aïd El-Fitr', 'date': DateTime(year, 3, 30)}, // Approximate
      {'title': 'Aïd El-Adha', 'date': DateTime(year, 6, 6)}, // Approximate
      // Vacances scolaires
      {'title': 'Vacances de Printemps', 'date': DateTime(year, 3, 15)},
      {'title': 'Fin des Cours - 1er Semestre', 'date': DateTime(year, 1, 15)},
      {'title': 'Début Examens Finaux', 'date': DateTime(year, 5, 15)},
    ];
    
    for (var holiday in holidays) {
      final holidayDate = holiday['date'] as DateTime;
      // Only add if the holiday is in the future or current month
      if (holidayDate.isAfter(now.subtract(const Duration(days: 30)))) {
        eventsList.add(CalendarEventModel(
          title: holiday['title'] as String,
          type: EventType.holiday,
          date: holidayDate,
          startTime: 'Toute la journée',
          location: '-',
        ));
      }
    }
  }

  Future<void> fetchEvents() async {
    return fetchAllEvents();
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
        return {'label': 'Congé', 'bg': const Color(0xFFE8F5E9), 'text': const Color(0xFF2E7D32)};
      case EventType.personal:
        return {'label': 'Personnel', 'bg': AppColors.tagPersoBg, 'text': AppColors.tagPersoText};
    }
  }
}