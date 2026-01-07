import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/professor_session_model.dart';
import '../services/auth_service.dart';

class ProfessorSessionViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  List<ProfessorOverview> _professorsOverview = [];
  List<ProfessorSessionModel> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProfessorOverview> get professorsOverview => _professorsOverview;
  List<ProfessorSessionModel> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<void> loadProfessorsOverview(DateTime date) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final dateString = date.toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('$baseUrl/admin/professors/sessions/overview?date=$dateString'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _professorsOverview = data
            .map((json) => ProfessorOverview.fromJson(json))
            .toList();
        _errorMessage = null;
      } else {
        throw Exception('Failed to load professors overview');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading professors overview: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProfessorSessions(String professorId, DateTime date) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final dateString = date.toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('$baseUrl/admin/professors/$professorId/sessions?date=$dateString'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _sessions = data
            .map((json) => ProfessorSessionModel.fromJson(json))
            .toList();
        _errorMessage = null;
      } else {
        throw Exception('Failed to load professor sessions');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error loading professor sessions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addSession({
    required String professorId,
    required String subject,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String room,
    required String sessionType,
    String? notes,
  }) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/admin/professors/$professorId/sessions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'subject': subject,
          'date': date.toIso8601String(),
          'startTime': startTime,
          'endTime': endTime,
          'room': room,
          'sessionType': sessionType,
          'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        await loadProfessorsOverview(date);
        _errorMessage = null;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to add session');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error adding session: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSession({
    required String sessionId,
    required Map<String, dynamic> updates,
  }) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/admin/sessions/$sessionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        // Refresh the data
        final updatedSession = ProfessorSessionModel.fromJson(json.decode(response.body));
        final sessionIndex = _sessions.indexWhere((s) => s.id == sessionId);
        if (sessionIndex != -1) {
          _sessions[sessionIndex] = updatedSession;
        }
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Failed to update session');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error updating session: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/admin/sessions/$sessionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _sessions.removeWhere((s) => s.id == sessionId);
        // Also update the overview if needed
        for (var overview in _professorsOverview) {
          overview.sessions.removeWhere((s) => s.id == sessionId);
        }
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Failed to delete session');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error deleting session: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markAttendance(String sessionId, bool attended) async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      await updateSession(
        sessionId: sessionId,
        updates: {
          'attended': attended,
          'status': attended ? 'completed' : 'missed',
        },
      );
    } catch (e) {
      print('Error marking attendance: $e');
      rethrow;
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
