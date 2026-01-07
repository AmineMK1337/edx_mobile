import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../models/timetable_model.dart';
import '../models/common/class_model.dart';

class TimetableViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final String baseUrl = 'http://localhost:5000/api/timetables';

  List<TimetableModel> _timetables = [];
  List<ClassModel> _classes = [];
  bool _isLoading = false;
  String? _error;

  List<TimetableModel> get timetables => _timetables;
  List<ClassModel> get classes => _classes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Get all timetables (admin only)
  Future<void> getAllTimetables() async {
    _setLoading(true);
    _setError(null);

    try {
      final token = await _authService.getToken();
      if (token == null) {
        _setError('No authentication token found');
        _setLoading(false);
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _timetables = data.map((json) => TimetableModel.fromJson(json)).toList();
      } else {
        _setError('Failed to load timetables');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get timetables by class
  Future<void> getTimetablesByClass(String classId) async {
    _setLoading(true);
    _setError(null);

    try {
      final token = await _authService.getToken();
      if (token == null) {
        _setError('No authentication token found');
        _setLoading(false);
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/class/$classId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _timetables = data.map((json) => TimetableModel.fromJson(json)).toList();
      } else {
        _setError('Failed to load timetables for class');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Upload timetable (admin only)
  Future<bool> uploadTimetable({
    required String title,
    required String description,
    required String classId,
    required String academicYear,
    required String semester,
    required File pdfFile,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final token = await _authService.getToken();
      if (token == null) {
        _setError('No authentication token found');
        _setLoading(false);
        return false;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['class'] = classId;
      request.fields['academicYear'] = academicYear;
      request.fields['semester'] = semester;

      request.files.add(
        await http.MultipartFile.fromPath('pdfFile', pdfFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(responseBody);
        final newTimetable = TimetableModel.fromJson(data);
        _timetables.insert(0, newTimetable);
        notifyListeners();
        return true;
      } else {
        final Map<String, dynamic> errorData = json.decode(responseBody);
        _setError(errorData['error'] ?? 'Failed to upload timetable');
        return false;
      }
    } catch (e) {
      _setError('Error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete timetable (admin only)
  Future<bool> deleteTimetable(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      final token = await _authService.getToken();
      if (token == null) {
        _setError('No authentication token found');
        _setLoading(false);
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _timetables.removeWhere((timetable) => timetable.id == id);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete timetable');
        return false;
      }
    } catch (e) {
      _setError('Error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Download timetable PDF
  Future<String?> downloadTimetable(String id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        _setError('No authentication token found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/download/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return response.headers['content-disposition'];
      } else {
        _setError('Failed to download timetable');
        return null;
      }
    } catch (e) {
      _setError('Error: $e');
      return null;
    }
  }

  // Load classes for dropdown
  Future<void> loadClasses() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        _setError('No authentication token found');
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:5000/api/classes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _classes = data.map((json) => ClassModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      _setError('Error loading classes: $e');
    }
  }
}