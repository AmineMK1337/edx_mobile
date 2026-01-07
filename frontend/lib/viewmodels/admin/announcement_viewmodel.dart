import 'package:flutter/material.dart';
import '../../models/admin/announcement_model.dart';
import '../../services/api_service.dart';

class AdminAnnouncementViewModel extends ChangeNotifier {
  List<AdminAnnouncement> _announcements = [];
  bool _isLoading = false;
  String _selectedFilter = 'Tous';

  List<AdminAnnouncement> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;

  int get allCount => _announcements.length;
  int get publishedCount => _announcements.where((a) => a.status == 'Publié').length;
  int get scheduledCount => _announcements.where((a) => a.status == 'Programmé').length;
  int get draftCount => _announcements.where((a) => a.status == 'Brouillon').length;

  AdminAnnouncementViewModel() {
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/announcements');
      if (response != null && response is List) {
        _announcements = response.map((json) => AdminAnnouncement.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _announcements = [
        AdminAnnouncement(id: '1', title: 'Calendrier des examens', date: '2024-01-15', audience: 'Tous', status: 'Publié', views: 245),
        AdminAnnouncement(id: '2', title: 'Réunion pédagogique', date: '2024-01-14', audience: 'Profs', status: 'Programmé', views: 0),
        AdminAnnouncement(id: '3', title: 'Changement d\'emploi du temps', date: '2024-01-13', audience: 'Étudiants', status: 'Brouillon', views: 0),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<AdminAnnouncement> getFilteredAnnouncements() {
    if (_selectedFilter == 'Tous') {
      return _announcements;
    }
    return _announcements.where((a) => a.status == _selectedFilter).toList();
  }

  Future<bool> addAnnouncement(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/admin/announcements', data);
      if (response != null) {
        await fetchAnnouncements();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> deleteAnnouncement(String id) async {
    try {
      final response = await ApiService.delete('/admin/announcements/$id');
      if (response != null) {
        await fetchAnnouncements();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
