import 'package:flutter/material.dart';
import '../models/about_model.dart';
import '../services/api_service.dart';

class AboutViewModel extends ChangeNotifier {
  AboutModel? _aboutData;
  bool _isLoading = false;
  String? _error;

  AboutModel? get aboutData => _aboutData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AboutViewModel() {
    loadAboutData();
  }

  Future<void> loadAboutData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/school-info');
      _aboutData = AboutModel.fromJson(response);
    } catch (e) {
      debugPrint("Error loading about data: $e");
      _error = e.toString();
      // Fallback to default data
      _aboutData = AboutModel(
        presentation: "L'École Supérieure des Communications de Tunis est la grande école d'ingénieurs des télécommunications en Tunisie.",
        studentsCount: "1200+",
        teachersCount: "90+",
        partnersCount: "30+",
        labsCount: "15",
        departments: [
          "Réseaux et Services",
          "Systèmes de Communications",
          "Technologies du Numérique",
          "Langues et Management",
        ],
        address: "Cité Technologique des Communications, Raoued",
        phone: "+216 70 011 000",
        website: "www.supcom.tn",
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}
