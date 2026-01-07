import 'package:flutter/material.dart';
import '../../models/admin/admin_model.dart';
import '../../services/api_service.dart';

class AdminViewModel extends ChangeNotifier {
  AdminDashboardStats? _stats;
  List<AdminMenuItem> _menuItems = [];
  bool _isLoading = false;

  AdminDashboardStats? get stats => _stats;
  List<AdminMenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;

  AdminViewModel() {
    _initMenuItems();
    _initializeAndFetch();
  }

  Future<void> _initializeAndFetch() async {
    await ApiService.loadToken();
    await fetchStats();
  }

  void _initMenuItems() {
    _menuItems = [
      AdminMenuItem(
        title: 'Utilisateurs',
        icon: Icons.people,
        color: Colors.blue,
      ),
      AdminMenuItem(
        title: 'Tickets',
        icon: Icons.confirmation_number,
        color: Colors.orange,
      ),
      AdminMenuItem(
        title: 'Rattrapages',
        icon: Icons.refresh,
        color: Colors.green,
      ),
      AdminMenuItem(
        title: 'Annonces',
        icon: Icons.campaign,
        color: Colors.purple,
      ),
      AdminMenuItem(
        title: 'Emploi du temps',
        icon: Icons.calendar_today,
        color: Colors.teal,
      ),
      AdminMenuItem(
        title: 'Matières',
        icon: Icons.book,
        color: Colors.indigo,
      ),
      AdminMenuItem(
        title: 'Salles',
        icon: Icons.meeting_room,
        color: Colors.brown,
      ),
      AdminMenuItem(
        title: 'Documents',
        icon: Icons.description,
        color: Colors.red,
      ),
      AdminMenuItem(
        title: 'Publier Notes',
        icon: Icons.grade,
        color: Colors.pink,
      ),
      AdminMenuItem(
        title: 'Emplois PDF',
        icon: Icons.picture_as_pdf,
        color: Colors.deepOrange,
      ),
      AdminMenuItem(
        title: 'Sessions Prof',
        icon: Icons.person_pin,
        color: Colors.cyan,
      ),
      AdminMenuItem(
        title: 'Chat',
        icon: Icons.chat,
        color: Colors.lightGreen,
      ),
    ];
  }

  Future<void> fetchStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/stats', requiresAuth: true);
      if (response != null) {
        _stats = AdminDashboardStats.fromJson(response);
      }
    } catch (e) {
      print('Error fetching stats: $e');
      // Fallback mock data
      _stats = AdminDashboardStats(
        ticketsCount: 12,
        usersCount: 450,
        rattrapagesCount: 8,
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}
