enum AbsenceStatus { present, absent, late, justified }
enum SessionType { course, tp, td, exam }

class AbsenceModel {
  final String? id;
  final String? studentId;
  final String? courseId;
  final String? classId;
  final SessionType sessionType;
  final DateTime date;
  final AbsenceStatus status;
  final String? justificationDocument;
  final String? takenById;
  final String? academicYearId;

  // Populated fields
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? course;
  final Map<String, dynamic>? classDetails;
  final Map<String, dynamic>? takenBy;
  final Map<String, dynamic>? academicYear;

  AbsenceModel({
    this.id,
    this.studentId,
    this.courseId,
    this.classId,
    required this.sessionType,
    required this.date,
    required this.status,
    this.justificationDocument,
    this.takenById,
    this.academicYearId,
    this.student,
    this.course,
    this.classDetails,
    this.takenBy,
    this.academicYear,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModel(
      id: json['_id'],
      studentId: json['student'] is String ? json['student'] : json['student']?['_id'],
      courseId: json['course'] is String ? json['course'] : json['course']?['_id'],
      classId: json['class'] is String ? json['class'] : json['class']?['_id'],
      sessionType: _parseSessionType(json['sessionType']),
      date: DateTime.parse(json['date']),
      status: _parseStatus(json['status'] ?? json['statusDetail']),
      justificationDocument: json['justificationDocument'],
      takenById: json['takenBy'] is String ? json['takenBy'] : json['takenBy']?['_id'],
      academicYearId: json['academicYear'] is String ? json['academicYear'] : json['academicYear']?['_id'],
      student: json['student'] is Map ? json['student'] : null,
      course: json['course'] is Map ? json['course'] : null,
      classDetails: json['class'] is Map ? json['class'] : null,
      takenBy: json['takenBy'] is Map ? json['takenBy'] : null,
      academicYear: json['academicYear'] is Map ? json['academicYear'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (studentId != null) 'student': studentId,
      if (courseId != null) 'course': courseId,
      if (classId != null) 'class': classId,
      'sessionType': _sessionTypeToString(sessionType),
      'date': date.toIso8601String(),
      'status': _statusToString(status),
      if (justificationDocument != null) 'justificationDocument': justificationDocument,
      if (takenById != null) 'takenBy': takenById,
      if (academicYearId != null) 'academicYear': academicYearId,
    };
  }

  static AbsenceStatus _parseStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'present':
        return AbsenceStatus.present;
      case 'late':
      case 'retard':
        return AbsenceStatus.late;
      case 'justified':
        return AbsenceStatus.justified;
      default:
        return AbsenceStatus.absent;
    }
  }

  static String _statusToString(AbsenceStatus status) {
    switch (status) {
      case AbsenceStatus.present:
        return 'present';
      case AbsenceStatus.late:
        return 'late';
      case AbsenceStatus.justified:
        return 'justified';
      default:
        return 'absent';
    }
  }

  static SessionType _parseSessionType(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'tp':
        return SessionType.tp;
      case 'td':
        return SessionType.td;
      case 'exam':
        return SessionType.exam;
      default:
        return SessionType.course;
    }
  }

  static String _sessionTypeToString(SessionType type) {
    switch (type) {
      case SessionType.tp:
        return 'tp';
      case SessionType.td:
        return 'td';
      case SessionType.exam:
        return 'exam';
      default:
        return 'course';
    }
  }

  String get studentName => student?['name'] ?? 'N/A';
  String get courseName => course?['title'] ?? 'N/A';
  String get className => classDetails?['name'] ?? 'N/A';
  String get takenByName => takenBy?['name'] ?? 'N/A';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  String get formattedTime => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  
  // Backward compatibility properties for UI
  String get subject => courseName;
  String get time => formattedTime;
  int? get absentCount => null; // This would need to be calculated or passed separately
  String get sessionTypeString => _sessionTypeToString(sessionType);
}