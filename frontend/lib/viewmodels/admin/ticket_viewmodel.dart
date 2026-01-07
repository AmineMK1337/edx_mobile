import 'package:flutter/material.dart';
import '../../models/admin/ticket_model.dart';
import '../../services/api_service.dart';

class AdminTicketViewModel extends ChangeNotifier {
  List<AdminTicket> _tickets = [];
  List<AdminTicket> _filteredTickets = [];
  bool _isLoading = false;
  String _selectedFilter = 'Tous';

  List<AdminTicket> get tickets => _filteredTickets.isEmpty && _selectedFilter == 'Tous' ? _tickets : _filteredTickets;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;

  int get nouveauCount => _tickets.where((t) => t.status == 'nouveau').length;
  int get enCoursCount => _tickets.where((t) => t.status == 'en cours').length;
  int get resoluCount => _tickets.where((t) => t.status == 'resolu').length;

  AdminTicketViewModel() {
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/tickets');
      if (response != null && response is List) {
        _tickets = response.map((json) => AdminTicket.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _tickets = [
        AdminTicket(id: '1', title: 'Problème avec emploi du temps', userName: 'Ahmed', category: 'Scolarité', date: '2024-01-15', priority: 'haute', status: 'nouveau'),
        AdminTicket(id: '2', title: 'Demande de relevé de notes', userName: 'Sami', category: 'Documents', date: '2024-01-14', priority: 'moyenne', status: 'en cours'),
        AdminTicket(id: '3', title: 'Question sur rattrapage', userName: 'Fatma', category: 'Examen', date: '2024-01-13', priority: 'basse', status: 'resolu'),
      ];
    }

    _filteredTickets = List.from(_tickets);
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    if (filter == 'Tous') {
      _filteredTickets = List.from(_tickets);
    } else {
      _filteredTickets = _tickets.where((t) => t.status == filter).toList();
    }
    notifyListeners();
  }

  Future<bool> updateTicketStatus(String id, String status) async {
    try {
      final response = await ApiService.put('/admin/tickets/$id', {'status': status});
      if (response != null) {
        await fetchTickets();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  AdminTicket? getTicketById(String id) {
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
