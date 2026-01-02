class EnrollmentModel {
  final String? id;
  final String student;
  final String course;
  final String classId;
  final String academicYear;
  final String status;
  final DateTime enrollmentDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Populated fields
  final Map<String, dynamic>? studentDetails;
  final Map<String, dynamic>? courseDetails;
  final Map<String, dynamic>? classDetails;
  final Map<String, dynamic>? academicYearDetails;

  EnrollmentModel({
    this.id,
    required this.student,
    required this.course,
    required this.classId,
    required this.academicYear,
    this.status = 'active',
    required this.enrollmentDate,
    this.createdAt,
    this.updatedAt,
    this.studentDetails,
    this.courseDetails,
    this.classDetails,
    this.academicYearDetails,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['_id'],
      student: json['student'] is String 
          ? json['student']
          : json['student']?['_id'],
      course: json['course'] is String 
          ? json['course']
          : json['course']?['_id'],
      classId: json['class'] is String 
          ? json['class']
          : json['class']?['_id'],
      academicYear: json['academicYear'] is String 
          ? json['academicYear']
          : json['academicYear']?['_id'],
      status: json['status'] ?? 'active',
      enrollmentDate: DateTime.parse(json['enrollmentDate']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      studentDetails: json['student'] is Map ? json['student'] : null,
      courseDetails: json['course'] is Map ? json['course'] : null,
      classDetails: json['class'] is Map ? json['class'] : null,
      academicYearDetails: json['academicYear'] is Map ? json['academicYear'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'student': student,
      'course': course,
      'class': classId,
      'academicYear': academicYear,
      'status': status,
      'enrollmentDate': enrollmentDate.toIso8601String(),
    };
  }
}
