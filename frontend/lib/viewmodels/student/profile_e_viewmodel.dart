import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/student/profile_e_model.dart';
import '../../services/api_service.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/profile/$id');
      _profile = ProfileModel.fromJson(response);
    } catch (e) {
      debugPrint("Erreur : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(String id, {String? phone, String? address}) async {
    try {
      final data = <String, dynamic>{};
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;

      await ApiService.put('/profile/$id', data);
      // Reload profile after update
      await fetchProfile(id);
    } catch (e) {
      debugPrint("Erreur update profile: $e");
    }
  }
}