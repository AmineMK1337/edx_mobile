import 'package:flutter/material.dart';
import '../../models/professor/note_model.dart';
import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

class NotesViewModel extends ChangeNotifier {
  List<NoteModel> notes = [];
  bool isLoading = false;
  String? error;

  NotesViewModel() {
    if (ApiService.getToken() != null) {
      fetchNotes();
    }
  }

  Future<void> fetchNotes() async {
    if (ApiService.getToken() == null) return;
    
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/notes', requiresAuth: true);

      if (response is List) {
        notes = response
            .whereType<Map>()
            .map((data) => NoteModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        notes = [];
      }

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Helper pour obtenir les propriétés de style selon le statut de publication
  Map<String, dynamic> getStatusProps(bool isPublished) {
    if (isPublished) {
      return {
        "text": "Publiée",
        "bg": AppColors.statusPublieeBg,
        "textColor": AppColors.statusPublieeText,
        "iconColor": Colors.green,
        "iconBg": AppColors.iconBgGreen,
      };
    } else {
      return {
        "text": "En attente",
        "bg": AppColors.statusEnAttenteBg,
        "textColor": AppColors.statusEnAttenteText,
        "iconColor": Colors.orange,
        "iconBg": AppColors.statusEnAttenteBg,
      };
    }
  }
}