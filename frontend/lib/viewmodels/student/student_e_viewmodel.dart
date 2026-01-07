import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/student/student_e_model.dart';

class StudentViewModel extends ChangeNotifier {
  StudentModel? _student;
  bool _isLoading = true;

  // Getters pour la View
  StudentModel? get student => _student;
  bool get isLoading => _isLoading;

  final String studentId = "69568094a80bc4f943d55964";
  final String serverUrl = "http://localhost:5000/api/students";

  Future<void> fetchStudent() async {
    _isLoading = true;
    notifyListeners(); // Prévient la vue qu'on charge

    try {
      final response = await http.get(Uri.parse('$serverUrl/$studentId'));
      if (response.statusCode == 200) {
        _student = StudentModel.fromJson(json.decode(response.body));
      } else {
        debugPrint("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erreur de connexion : $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Prévient la vue que c'est fini
    }
  }
}
