import 'package:flutter/foundation.dart';
import '../models/shared_doc_e_model.dart';
import '../services/api_service.dart';

class PartageViewModel extends ChangeNotifier {
  List<SharedDocModel> _documents = [];
  bool _isLoading = true;
  
  String selectedMatiere = "Toutes les matières";
  String selectedType = "Tous les types";

  List<SharedDocModel> get documents => _documents;
  bool get isLoading => _isLoading;

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/shared-docs', requiresAuth: true);
      
      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _documents = data.map((json) => SharedDocModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur PartageViewModel: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateMatiere(String newValue) {
    selectedMatiere = newValue;
    notifyListeners();
    // Ici tu pourrais ajouter une logique de filtrage local si nécessaire
  }

  void updateType(String newValue) {
    selectedType = newValue;
    notifyListeners();
  }
}