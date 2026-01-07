class CourseModel {
  final String? id;
  final String title;
  final String code;
  final String? level;
  final String? classId;
  final int studentCount;
  final int hoursPerWeek;
  final DateTime? nextDayTime;
  final String? location;
  final String? professorId;
  final String? academicYearId;
  final bool isActive;

  // Populated fields
  final Map<String, dynamic>? professor;
  final Map<String, dynamic>? classDetails;
  final Map<String, dynamic>? academicYear;

  CourseModel({
    this.id,
    required this.title,
    required this.code,
    this.level,
    this.classId,
    this.studentCount = 0,
    this.hoursPerWeek = 0,
    this.nextDayTime,
    this.location,
    this.professorId,
    this.academicYearId,
    this.isActive = true,
    this.professor,
    this.classDetails,
    this.academicYear,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'],
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      level: json['level'],
      classId: json['class'] is String ? json['class'] : json['class']?['_id'],
      studentCount: json['studentCount'] ?? 0,
      hoursPerWeek: json['hoursPerWeek'] ?? 0,
      nextDayTime: json['nextDayTime'] != null ? DateTime.parse(json['nextDayTime']) : null,
      location: json['location'],
      professorId: json['professor'] is String ? json['professor'] : json['professor']?['_id'],
      academicYearId: json['academicYear'] is String ? json['academicYear'] : json['academicYear']?['_id'],
      isActive: json['isActive'] ?? true,
      professor: json['professor'] is Map ? json['professor'] : null,
      classDetails: json['class'] is Map ? json['class'] : null,
      academicYear: json['academicYear'] is Map ? json['academicYear'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'code': code,
      if (level != null) 'level': level,
      if (classId != null) 'class': classId,
      'studentCount': studentCount,
      'hoursPerWeek': hoursPerWeek,
      if (nextDayTime != null) 'nextDayTime': nextDayTime!.toIso8601String(),
      if (location != null) 'location': location,
      if (professorId != null) 'professor': professorId,
      if (academicYearId != null) 'academicYear': academicYearId,
      'isActive': isActive,
    };
  }

  String get professorName => professor?['name'] ?? 'N/A';
  String get className => classDetails?['name'] ?? 'N/A';
  String get academicYearDisplay => academicYear?['year'] ?? 'N/A';
}
