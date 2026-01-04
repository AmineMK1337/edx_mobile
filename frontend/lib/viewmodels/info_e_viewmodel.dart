import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/info_e_model.dart';

class InfoViewModel extends ChangeNotifier {
  List<InfoNote> _notes = [];
  bool _isLoading = true;

  List<InfoNote> get notes => _notes;
  bool get isLoading => _isLoading;

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/info-notes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _notes = data.map((json) => InfoNote.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Erreur InfoViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case "Emploi du temps": return Icons.schedule;
      case "Vie associative": return Icons.group_add;
      case "Examen": return Icons.assignment;
      case "Général": return Icons.people;
      default: return Icons.info;
    }
  }
}