import '../models/user_model.dart';

class ProfessorSessionModel {
  final String id;
  final UserModel? professor;
  final String? subject;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? room;
  final String sessionType;
  final String status;
  final bool attended;
  final String? notes;
  final DateTime createdAt;

  ProfessorSessionModel({
    required this.id,
    this.professor,
    this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.room,
    required this.sessionType,
    required this.status,
    required this.attended,
    this.notes,
    required this.createdAt,
  });

  factory ProfessorSessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessorSessionModel(
      id: json['_id'] ?? '',
      professor: json['professor'] != null ? UserModel.fromJson(json['professor']) : null,
      subject: json['subject'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'],
      sessionType: json['sessionType'] ?? 'lecture',
      status: json['status'] ?? 'scheduled',
      attended: json['attended'] ?? false,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'professor': professor?.toJson(),
      'subject': subject,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'sessionType': sessionType,
      'status': status,
      'attended': attended,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ProfessorOverview {
  final UserModel professor;
  final int sessionCount;
  final List<ProfessorSessionModel> sessions;
  final bool hasSession;
  final double totalHours;

  ProfessorOverview({
    required this.professor,
    required this.sessionCount,
    required this.sessions,
    required this.hasSession,
    required this.totalHours,
  });

  factory ProfessorOverview.fromJson(Map<String, dynamic> json) {
    return ProfessorOverview(
      professor: UserModel.fromJson(json['professor']),
      sessionCount: json['sessionCount'] ?? 0,
      sessions: (json['sessions'] as List? ?? [])
          .map((s) => ProfessorSessionModel.fromJson(s))
          .toList(),
      hasSession: json['hasSession'] ?? false,
      totalHours: (json['totalHours'] ?? 0.0).toDouble(),
    );
  }
}
