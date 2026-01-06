import 'package:flutter/material.dart';
import '../../models/common/general_info_model.dart';
import '../../services/api_service.dart';

class GeneralInfoViewModel extends ChangeNotifier {
  GeneralInfoModel? _infoData;
  bool _isLoading = false;
  String? _error;

  GeneralInfoModel? get infoData => _infoData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  GeneralInfoViewModel() {
    loadInfoData();
  }

  Future<void> loadInfoData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/general-info');
      _infoData = GeneralInfoModel.fromJson(response);
    } catch (e) {
      debugPrint("Error loading general info: $e");
      _error = e.toString();
      // Fallback to default data
      _infoData = GeneralInfoModel(
        announcement: "Annonce importante: Les inscriptions pour les examens de rattrapage sont ouvertes jusqu'au 20 novembre 2024.",
        faqs: [
          {"q": "Comment consulter mes notes ?", "a": "Via le portail étudiant section Résultats."},
          {"q": "Comment justifier une absence ?", "a": "Envoyez un justificatif à la scolarité sous 48h."},
        ],
        events: [
          CalendarEventInfo("Semestre 1", "16 sept 2024 - 15 jan 2025", "En cours", Colors.blue),
          CalendarEventInfo("Examens S1", "20 jan - 05 fév 2025", "À venir", Colors.grey),
          CalendarEventInfo("Vacances d'hiver", "06 fév - 16 fév 2025", "À venir", Colors.grey),
        ],
        services: [
          {"name": "Scolarité", "bureau": "Bureau A.1.01", "email": "scolarite@supcom.tn"},
          {"name": "Bibliothèque", "bureau": "Bâtiment c", "email": "biblio@supcom.tn"},
        ],
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}
