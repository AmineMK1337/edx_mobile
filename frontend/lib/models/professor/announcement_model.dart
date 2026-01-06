import 'package:flutter/material.dart';

class AnnouncementModel {
  final String? id;
  final String title;
  final String content;
  final String classId;
  final String createdById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final String priority; // low, medium, high
  
  // Populated fields
  final Map<String, dynamic>? createdBy;
  final Map<String, dynamic>? classDetails;

  AnnouncementModel({
    this.id,
    required this.title,
    required this.content,
    required this.classId,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.priority = 'medium',
    this.createdBy,
    this.classDetails,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      classId: json['class'] is String ? json['class'] : json['class']?['_id'] ?? '',
      createdById: json['createdBy'] is String ? json['createdBy'] : json['createdBy']?['_id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      isPinned: json['isPinned'] ?? false,
      priority: json['priority'] ?? 'medium',
      createdBy: json['createdBy'] is Map ? json['createdBy'] : null,
      classDetails: json['class'] is Map ? json['class'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'content': content,
      'class': classId,
      'createdBy': createdById,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'priority': priority,
    };
  }

  String get creatorName => createdBy?['name'] ?? 'Utilisateur';
  String get creatorEmail => createdBy?['email'] ?? '';
  String get creatorRole => createdBy?['role'] ?? '';
  String get className => classDetails?['name'] ?? '';

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final announcementDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (announcementDate == today) {
      return 'Aujourd\'hui à ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (announcementDate == yesterday) {
      return 'Hier';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFFFA500);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF2196F3);
    }
  }

  String get priorityLabel {
    switch (priority) {
      case 'high':
        return 'Haute priorité';
      case 'medium':
        return 'Priorité normale';
      case 'low':
        return 'Basse priorité';
      default:
        return 'Normale';
    }
  }
}
