import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/profile_e_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;

  // Remplace localhost par 10.0.2.2 si tu es sur émulateur Android
  final String serverUrl = "http://localhost:5000/api/students";

  Future<void> fetchProfile(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$serverUrl/$id'));
      if (response.statusCode == 200) {
        _profile = ProfileModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Erreur : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}