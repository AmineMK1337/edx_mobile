import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/shared_doc_e_model.dart';

class PartageViewModel extends ChangeNotifier {
  List<SharedDocModel> _documents = [];
  bool _isLoading = true;
  
  String selectedMatiere = "Toutes les matières";
  String selectedType = "Tous les types";

  List<SharedDocModel> get documents => _documents;
  bool get isLoading => _isLoading;

  final String serverIP = "192.168.100.17";
  final String port = "5000";

  String get _baseUrl => kIsWeb ? 'http://localhost:$port' : 'http://$serverIP:$port';

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/shared-docs'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _documents = data.map((json) => SharedDocModel.fromJson(json)).toList();
      }
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