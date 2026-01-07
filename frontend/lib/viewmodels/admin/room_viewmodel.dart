import 'package:flutter/material.dart';
import '../../models/admin/room_model.dart';
import '../../services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminRoomViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  List<AdminRoom> _rooms = [];
  List<AdminRoom> _filteredRooms = [];
  bool _isLoading = false;
  String _selectedType = 'Tous';
  String? _errorMessage;

  List<AdminRoom> get rooms => _filteredRooms.isEmpty && _selectedType == 'Tous' ? _rooms : _filteredRooms;
  bool get isLoading => _isLoading;
  String get selectedType => _selectedType;
  String? get errorMessage => _errorMessage;
  String? get error => _errorMessage;

  static const String baseUrl = 'http://localhost:5000/api';

  int get freeCount => _rooms.where((r) => r.status == 'available').length;
  int get occupiedCount => _rooms.where((r) => r.status == 'occupied').length;
  int get maintenanceCount => _rooms.where((r) => r.status == 'maintenance').length;
  int get reservedCount => _rooms.where((r) => r.status == 'reserved').length;

  AdminRoomViewModel() {
    _initializeAndFetch();
  }

  Future<void> _initializeAndFetch() async {
    // Ensure token is loaded from storage
    await _authService.getToken();
    await fetchRooms();
  }

  Future<void> fetchRooms() async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/rooms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response type: ${data.runtimeType}');
        print('API Response: $data');
        
        List<dynamic> roomsList;
        if (data is List) {
          roomsList = data;
        } else if (data is Map && data['rooms'] != null) {
          roomsList = data['rooms'] as List;
        } else {
          throw Exception('Unexpected API response format');
        }
        
        _rooms = roomsList
            .map((json) => AdminRoom.fromJson(json as Map<String, dynamic>))
            .toList();
        _filteredRooms = List.from(_rooms);
        _errorMessage = null;
      } else {
        throw Exception('Failed to fetch rooms: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error fetching rooms: $e');
      // Fallback to empty list instead of mock data for production
      _rooms = [];
      _filteredRooms = [];
    } finally {
      _setLoading(false);
    }
  }

  void setTypeFilter(String type) {
    _selectedType = type;
    if (type == 'Tous') {
      _filteredRooms = List.from(_rooms);
    } else {
      _filteredRooms = _rooms.where((r) => r.type == type).toList();
    }
    notifyListeners();
  }

  Future<bool> addRoom(dynamic roomData) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      // Convert AdminRoom to Map if needed
      final data = roomData is AdminRoom ? roomData.toJson() : roomData as Map<String, dynamic>;

      final response = await http.post(
        Uri.parse('$baseUrl/admin/rooms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        await fetchRooms();
        _errorMessage = null;
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to add room');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error adding room: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateRoom(String id, dynamic roomData) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      // Convert AdminRoom to Map if needed
      final data = roomData is AdminRoom ? roomData.toJson() : roomData as Map<String, dynamic>;

      final response = await http.put(
        Uri.parse('$baseUrl/admin/rooms/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        await fetchRooms();
        _errorMessage = null;
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update room');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error updating room: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteRoom(String id) async {
    _setLoading(true);
    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/admin/rooms/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await fetchRooms();
        _errorMessage = null;
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to delete room');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error deleting room: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateRoomStatus(String id, String newStatus) async {
    return await updateRoom(id, {'status': newStatus});
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  List<String> get roomTypes => [
    'Tous',
    'Amphithéâtre', 
    'TD', 
    'Laboratoire', 
    'Bureau', 
    'Salle de réunion'
  ];

  List<String> get roomStatuses => [
    'available',
    'occupied', 
    'maintenance', 
    'reserved'
  ];
}
