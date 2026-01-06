import 'package:flutter/material.dart';
import '../models/document_e_model.dart';
import '../services/api_service.dart';

class DocumentViewModel extends ChangeNotifier {
  List<SchoolDocument> _allDocuments = [];
  String _selectedCategory = "Tout";
  bool _isLoading = true;

  final List<String> categories = ["Tout", "Cours", "TD", "TP"];

  List<SchoolDocument> get filteredDocuments {
    if (_selectedCategory == "Tout") return _allDocuments;
    return _allDocuments.where((doc) => doc.category == _selectedCategory).toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/documents', requiresAuth: true);
      
      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _allDocuments = data.map((json) => SchoolDocument.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur DocumentViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case "Cours": return Icons.menu_book;
      case "TD": return Icons.edit_note;
      case "TP": return Icons.computer;
      default: return Icons.insert_drive_file;
    }
  }
}