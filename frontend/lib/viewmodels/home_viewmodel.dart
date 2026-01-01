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
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Fetch data from APIs
      final schedules = await ApiService.get('/schedules');
      final exams = await ApiService.get('/exams');
      
      // Update stats
      stats = {
        "Cours": (schedules is List ? schedules.length : 0).toString(),
        "Étudiants": "156", // TODO: fetch from API
        "Examens": (exams is List ? exams.length : 0).toString(),
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

