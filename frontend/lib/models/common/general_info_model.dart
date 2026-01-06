import 'package:flutter/material.dart';

class CalendarEventInfo {
  final String title;
  final String date;
  final String status;
  final Color statusColor;

  CalendarEventInfo(this.title, this.date, this.status, this.statusColor);

  factory CalendarEventInfo.fromJson(Map<String, dynamic> json) {
    Color color;
    switch (json['status']) {
      case 'En cours':
        color = Colors.blue;
        break;
      case 'Terminé':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return CalendarEventInfo(
      json['title'] ?? '',
      json['date'] ?? '',
      json['status'] ?? 'À venir',
      color,
    );
  }
}

class GeneralInfoModel {
  final String announcement;
  final List<Map<String, String>> faqs;
  final List<CalendarEventInfo> events;
  final List<Map<String, String>> services;

  GeneralInfoModel({
    required this.announcement,
    required this.faqs,
    required this.events,
    required this.services,
  });

  factory GeneralInfoModel.fromJson(Map<String, dynamic> json) {
    return GeneralInfoModel(
      announcement: json['announcement'] ?? '',
      faqs: (json['faqs'] as List?)
              ?.map((e) => Map<String, String>.from(e))
              .toList() ??
          [],
      events: (json['events'] as List?)
              ?.map((e) => CalendarEventInfo.fromJson(e))
              .toList() ??
          [],
      services: (json['services'] as List?)
              ?.map((e) => Map<String, String>.from(e))
              .toList() ??
          [],
    );
  }
}
