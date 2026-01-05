import 'package:flutter/material.dart';
import 'package:my_app/models/menu_item.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/services/api_service.dart';

class HomeViewModel extends ChangeNotifier {
  Map<String, String> stats = {
    "Cours": "0",
    "Étudiants": "0",
    "Examens": "0",
  };

  bool isLoading = false;
  String? error;
  
  // User info
  String get userName => ApiService.getUserName();
  String get userRole => ApiService.getUserRole();

  // The list of grid items
  final List<DashboardMenuItem> menuItems = [
    DashboardMenuItem(title: "Mes Cours", icon: Icons.menu_book, iconColor: Colors.green, iconBgColor: AppColors.iconBgGreen),
    DashboardMenuItem(title: "Étudiants", icon: Icons.group, iconColor: Colors.blue, iconBgColor: AppColors.iconBgBlue),
    DashboardMenuItem(title: "Notes", icon: Icons.assignment_turned_in, iconColor: Colors.teal, iconBgColor: AppColors.iconBgGreen),
    DashboardMenuItem(title: "Absences", icon: Icons.calendar_today_outlined, iconColor: Colors.redAccent, iconBgColor: Color(0xFFFFEBEE)),
    DashboardMenuItem(title: "Emploi", icon: Icons.calendar_month, iconColor: Colors.purple, iconBgColor: AppColors.iconBgPurple),
    DashboardMenuItem(title: "Documents", icon: Icons.folder_open, iconColor: Colors.orange, iconBgColor: AppColors.iconBgOrange),
    DashboardMenuItem(title: "Messages", icon: Icons.chat_bubble_outline, iconColor: Colors.cyan, iconBgColor: Colors.cyan.withOpacity(0.1)),
    DashboardMenuItem(title: "Examens", icon: Icons.edit_note, iconColor: Colors.yellow[800]!, iconBgColor: AppColors.iconBgYellow),
    DashboardMenuItem(title: "Annonces", icon: Icons.campaign_outlined, iconColor: Colors.pinkAccent, iconBgColor: Colors.pink.withOpacity(0.1)),
    DashboardMenuItem(title: "Statistiques", icon: Icons.bar_chart, iconColor: Colors.indigo, iconBgColor: Colors.indigo.withOpacity(0.1)),
    DashboardMenuItem(title: "Calendrier", icon: Icons.date_range, iconColor: Colors.teal, iconBgColor: Colors.teal.withOpacity(0.1)),
    DashboardMenuItem(title: "Ressources", icon: Icons.library_books, iconColor: Colors.amber, iconBgColor: Colors.amber.withOpacity(0.1)),
  ];

  HomeViewModel() {
    // Only fetch stats if user is logged in (token exists)
    if (ApiService.getToken() != null) {
      fetchStats();
    }
  }

  Future<void> fetchStats() async {
    // Don't fetch if no token available
    if (ApiService.getToken() == null) {
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Fetch data from APIs
      final schedules = await ApiService.get('/schedules', requiresAuth: true);
      final exams = await ApiService.get('/exams', requiresAuth: true);
      final students = await ApiService.get('/users/students', requiresAuth: true);
      
      // Update stats
      stats = {
        "Cours": (schedules is List ? schedules.length : (schedules is Map && schedules['data'] is List ? (schedules['data'] as List).length : 0)).toString(),
        "Étudiants": (students is List ? students.length : (students is Map && students['data'] is List ? (students['data'] as List).length : 0)).toString(),
        "Examens": (exams is List ? exams.length : (exams is Map && exams['data'] is List ? (exams['data'] as List).length : 0)).toString(),
      };
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}

