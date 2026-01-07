import 'package:flutter/material.dart';
import '../../models/admin/user_model.dart';
import '../../services/api_service.dart';

class AdminUserViewModel extends ChangeNotifier {
  List<AdminUser> _users = [];
  List<AdminUser> _filteredUsers = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'Tous';

  List<AdminUser> get users => _filteredUsers.isEmpty && _searchQuery.isEmpty ? _users : _filteredUsers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  AdminUserViewModel() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/users');
      if (response != null && response is List) {
        _users = response.map((json) => AdminUser.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _users = [
        AdminUser(id: '1', name: 'Ahmed Ben Ali', email: 'ahmed@supcom.tn', role: 'Étudiant', details: '2A - RT', status: 'Actif'),
        AdminUser(id: '2', name: 'Sami Trabelsi', email: 'sami@supcom.tn', role: 'Professeur', details: 'Réseaux', status: 'Actif'),
        AdminUser(id: '3', name: 'Fatma Gharbi', email: 'fatma@supcom.tn', role: 'Administrateur', details: 'Admin', status: 'Actif'),
        AdminUser(id: '4', name: 'Mohamed Sassi', email: 'mohamed@supcom.tn', role: 'Étudiant', details: '3A - TIC', status: 'Inactif'),
      ];
    }

    _filteredUsers = List.from(_users);
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredUsers = _users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_selectedFilter == 'Tous') {
        return matchesSearch;
      }
      return matchesSearch && user.role == _selectedFilter;
    }).toList();
    notifyListeners();
  }

  Future<bool> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.post('/admin/users', userData);
      if (response != null) {
        await fetchUsers();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> updateUser(String id, Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.put('/admin/users/$id', userData);
      if (response != null) {
        await fetchUsers();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> deleteUser(String id) async {
    try {
      final response = await ApiService.delete('/admin/users/$id');
      if (response != null) {
        await fetchUsers();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
