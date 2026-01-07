import 'package:flutter/material.dart';
import '../../models/student/info_e_model.dart';
import '../../services/api_service.dart';

class InfoViewModel extends ChangeNotifier {
  List<InfoNote> _notes = [];
  bool _isLoading = true;

  List<InfoNote> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/announcements', requiresAuth: true);
      
      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _notes = data.map((json) => InfoNote.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur InfoViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case "Important": return Icons.priority_high;
      case "Général": return Icons.info;
      case "Info": return Icons.notifications;
      default: return Icons.info;
    }
  }
}
