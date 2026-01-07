import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/timetable_model.dart';
import '../services/auth_service.dart';

class TimetableViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  List<TimetableModel> _timetables = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TimetableModel> get timetables => _timetables;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<void> loadTimetables() async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/timetables'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _timetables = (data['timetables'] as List)
            .map((json) => TimetableModel.fromJson(json))
            .toList();
        _errorMessage = null;
      } else {
        throw Exception('Failed to load timetables');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading timetables: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadTimetable({
    required String filePath,
    required String fileName,
    required String targetType,
    required List<String> targetUsers,
    required String academicYear,
    required String semester,
    required String description,
  }) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/admin/timetables'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['targetType'] = targetType;
      request.fields['targetUsers'] = json.encode(targetUsers);
      request.fields['academicYear'] = academicYear;
      request.fields['semester'] = semester;
      request.fields['description'] = description;

      request.files.add(await http.MultipartFile.fromPath('pdfFile', filePath));

      final response = await request.send();
      
      if (response.statusCode == 201) {
        await loadTimetables(); // Refresh the list
        _errorMessage = null;
      } else {
        throw Exception('Failed to upload timetable');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error uploading timetable: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTimetable(String timetableId) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/admin/timetables/$timetableId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _timetables.removeWhere((t) => t.id == timetableId);
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Failed to delete timetable');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error deleting timetable: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<TimetableModel>> getUserTimetables(String userId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/$userId/timetable'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((json) => TimetableModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user timetables');
      }
    } catch (e) {
      print('Error loading user timetables: $e');
      return [];
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
