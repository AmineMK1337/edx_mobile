import 'package:flutter/material.dart';

class DashboardMenuItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const DashboardMenuItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}