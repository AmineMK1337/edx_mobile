import 'package:flutter/material.dart';
import '../../models/student/document_e_model.dart';
import '../../services/api_service.dart';

class DocumentViewModel extends ChangeNotifier {
  List<SchoolDocument> _allDocuments = [];
  String _selectedCategory = "Tout";
  bool _isLoading = true;

  final List<String> categories = ["Tout", "Mes publications", "Cours", "TD", "TP"];

  List<SchoolDocument> get filteredDocuments {
    if (_selectedCategory == "Tout") return _allDocuments;
    if (_selectedCategory == "Mes publications") {
      return _allDocuments.where((doc) => doc.category == "Publication").toList();
    }
    return _allDocuments.where((doc) => doc.category == _selectedCategory).toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Fetch administrative documents
      List<SchoolDocument> adminDocs = [];
      try {
        final response = await ApiService.get('/documents', requiresAuth: true);
        List<dynamic> data = [];
        if (response is List) {
          data = response;
        } else if (response is Map && response.containsKey('data')) {
          data = response['data'];
        }
        adminDocs = data.map((json) => SchoolDocument.fromJson(json)).toList();
      } catch (e) {
        debugPrint("Erreur fetching admin documents: $e");
      }

      // Fetch user's shared documents (publications)
      List<SchoolDocument> myDocs = [];
      try {
        final response = await ApiService.get('/shared-docs/my', requiresAuth: true);
        List<dynamic> data = [];
        if (response is List) {
          data = response;
        } else if (response is Map && response.containsKey('data')) {
          data = response['data'];
        }
        myDocs = data.map((json) => _sharedDocToSchoolDoc(json)).toList();
      } catch (e) {
        debugPrint("Erreur fetching my shared documents: $e");
      }

      _allDocuments = [...myDocs, ...adminDocs];
    } catch (e) {
      debugPrint("Erreur DocumentViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Convert shared doc JSON to SchoolDocument
  SchoolDocument _sharedDocToSchoolDoc(Map<String, dynamic> json) {
    String dateStr = "--/--/--";
    if (json['createdAt'] != null) {
      try {
        final date = DateTime.parse(json['createdAt']);
        dateStr = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (_) {}
    }

    return SchoolDocument(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Sans titre',
      category: "Publication",
      fileType: json['fileType'] ?? 'pdf',
      fileSize: '',
      date: dateStr,
      author: json['targetClass'] ?? 'Non spécifié',
      description: json['description'] ?? 'Aucune description.',
    );
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
      case "Publication": return Icons.cloud_upload;
      default: return Icons.insert_drive_file;
    }
  }
}
