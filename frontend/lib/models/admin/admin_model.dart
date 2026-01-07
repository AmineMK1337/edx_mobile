import 'package:flutter/material.dart';

// Menu item for admin dashboard grid
class AdminMenuItem {
  final String title;
  final IconData icon;
  final Color color;

  AdminMenuItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}

// Stats for admin dashboard header
class AdminDashboardStats {
  final int ticketsCount;
  final int usersCount;
  final int rattrapagesCount;

  AdminDashboardStats({
    required this.ticketsCount,
    required this.usersCount,
    required this.rattrapagesCount,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStats(
      ticketsCount: json['ticketsCount'] ?? 0,
      usersCount: json['usersCount'] ?? 0,
      rattrapagesCount: json['rattrapagesCount'] ?? 0,
    );
  }
}
