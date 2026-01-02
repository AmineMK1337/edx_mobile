enum ExamStatus { scheduled, completed, cancelled }

class ExamModel {
  final String? id;
  final String title;
  final String? courseId;
  final String? classId;
  final ExamStatus status;
  final DateTime date;
  final String startTime;
  final int studentCount;
  final int duration;
  final String location;
  final String? professorId;
  final String? academicYearId;

  // Populated fields
  final Map<String, dynamic>? course;
  final Map<String, dynamic>? classDetails;
  final Map<String, dynamic>? professor;
  final Map<String, dynamic>? academicYear;

  ExamModel({
    this.id,
    required this.title,
    this.courseId,
    this.classId,
    required this.status,
    required this.date,
    required this.startTime,
    required this.studentCount,
    required this.duration,
    required this.location,
    this.professorId,
    this.academicYearId,
    this.course,
    this.classDetails,
    this.professor,
    this.academicYear,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      courseId: json['course'] is String ? json['course'] : json['course']?['_id'],
      classId: json['class'] is String ? json['class'] : json['class']?['_id'],
      status: _parseStatus(json['status']),
      date: DateTime.parse(json['date']),
      startTime: json['startTime'] ?? json['time'] ?? '',
      studentCount: _parseInt(json['studentCount']),
      duration: _parseInt(json['duration']),
      location: json['location'] ?? '',
      professorId: json['professor'] is String ? json['professor'] : json['professor']?['_id'],
      academicYearId: json['academicYear'] is String ? json['academicYear'] : json['academicYear']?['_id'],
      course: json['course'] is Map ? json['course'] : null,
      classDetails: json['class'] is Map ? json['class'] : null,
      professor: json['professor'] is Map ? json['professor'] : null,
      academicYear: json['academicYear'] is Map ? json['academicYear'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      if (courseId != null) 'course': courseId,
      if (classId != null) 'class': classId,
      'status': _statusToString(status),
      'date': date.toIso8601String(),
      'startTime': startTime,
      'studentCount': studentCount,
      'duration': duration,
      'location': location,
      if (professorId != null) 'professor': professorId,
      if (academicYearId != null) 'academicYear': academicYearId,
    };
  }

  static ExamStatus _parseStatus(dynamic value) {
    switch (value) {
      case 'completed':
      case 'passe':
        return ExamStatus.completed;
      case 'cancelled':
        return ExamStatus.cancelled;
      default:
        return ExamStatus.scheduled;
    }
  }

  static String _statusToString(ExamStatus status) {
    switch (status) {
      case ExamStatus.completed:
        return 'completed';
      case ExamStatus.cancelled:
        return 'cancelled';
      default:
        return 'scheduled';
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get courseName => course?['title'] ?? 'N/A';
  String get className => classDetails?['name'] ?? 'N/A';
  String get professorName => professor?['name'] ?? 'N/A';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  
  // Backward compatibility properties for UI
  String get subject => courseName;
  String get time => startTime;
}