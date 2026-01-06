import 'package:flutter/material.dart';
import '../../models/professor/announcement_model.dart';
import '../../models/professor/course_model.dart';
import '../../services/api_service.dart';

class AnnouncementsViewModel extends ChangeNotifier {
  List<AnnouncementModel> announcements = [];
  List<CourseModel> courses = [];
  bool isLoading = false;
  String? error;

  AnnouncementsViewModel() {
    if (ApiService.getToken() != null) {
      fetchAnnouncements();
    }
  }

  Future<void> fetchAnnouncements() async {
    if (ApiService.getToken() == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      print('Fetching announcements');
      final response = await ApiService.get('/announcements', requiresAuth: true);

      if (response is List) {
        announcements = response
            .whereType<Map>()
            .map((data) => AnnouncementModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
        // Sort by pinned first, then by date
        announcements.sort((a, b) {
          if (a.isPinned != b.isPinned) {
            return a.isPinned ? -1 : 1;
          }
          return b.createdAt.compareTo(a.createdAt);
        });
      } else {
        announcements = [];
      }
      error = null;
    } catch (e) {
      print('Error fetching announcements: $e');
      error = 'Impossible de charger les annonces: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAnnouncement(String title, String content, String classId, String priority) async {
    if (ApiService.getToken() == null) return;

    try {
      print('Creating announcement with: title=$title, content=$content, classId=$classId, priority=$priority');
      final payload = {
        'title': title,
        'content': content,
        'classId': classId,
        'priority': priority,
      };
      print('Payload: $payload');
      
      final response = await ApiService.post(
        '/announcements',
        payload,
        requiresAuth: true,
      );

      print('Response: $response');
      if (response is Map) {
        // Refetch all announcements to ensure proper sorting
        await fetchAnnouncements();
        error = null;
      }
    } catch (e) {
      print('Error creating announcement: $e');
      error = 'Erreur lors de la création: $e';
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    if (ApiService.getToken() == null) return;

    try {
      await ApiService.delete('/announcements/$announcementId', requiresAuth: true);
      announcements.removeWhere((ann) => ann.id == announcementId);
      notifyListeners();
    } catch (e) {
      print('Error deleting announcement: $e');
      error = 'Erreur lors de la suppression: $e';
      notifyListeners();
    }
  }

  Future<void> togglePin(String announcementId) async {
    if (ApiService.getToken() == null) return;

    try {
      final response = await ApiService.put(
        '/announcements/$announcementId/toggle-pin',
        {},
        requiresAuth: true,
      );

      if (response is Map) {
        final updatedAnnouncement = AnnouncementModel.fromJson(Map<String, dynamic>.from(response));
        final index = announcements.indexWhere((ann) => ann.id == announcementId);
        if (index != -1) {
          announcements[index] = updatedAnnouncement;
          // Re-sort to move pinned items to top
          announcements.sort((a, b) {
            if (a.isPinned != b.isPinned) {
              return a.isPinned ? -1 : 1;
            }
            return b.createdAt.compareTo(a.createdAt);
          });
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error toggling pin: $e');
      error = 'Erreur lors de la mise à jour: $e';
      notifyListeners();
    }
  }
}
