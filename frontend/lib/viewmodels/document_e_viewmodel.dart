import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/document_e_model.dart';

class DocumentViewModel extends ChangeNotifier {
  List<SchoolDocument> _allDocuments = [];
  String _selectedCategory = "Tout";
  bool _isLoading = true;

  final List<String> categories = ["Tout", "Attestations", "Notes", "Stages", "Divers"];

  List<SchoolDocument> get filteredDocuments {
    if (_selectedCategory == "Tout") return _allDocuments;
    return _allDocuments.where((doc) => doc.category == _selectedCategory).toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/documents'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _allDocuments = data.map((json) => SchoolDocument.fromJson(json)).toList();
      }
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
      case "Attestations": return Icons.description;
      case "Notes": return Icons.assignment_turned_in;
      case "Stages": return Icons.work;
      case "Divers": return Icons.credit_card;
      default: return Icons.insert_drive_file;
    }
  }
}