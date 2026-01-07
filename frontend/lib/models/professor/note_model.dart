class NoteModel {
  final String? id;
  final String? studentId;
  final String? courseId;
  final String? examId;
  final String type;
  final double value;
  final double coefficient;
  final String? publishedById;
  final String? academicYearId;
  final bool isPublished;
  final DateTime? createdAt;

  // Populated fields
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? course;
  final Map<String, dynamic>? exam;
  final Map<String, dynamic>? publishedBy;
  final Map<String, dynamic>? academicYear;

  NoteModel({
    this.id,
    this.studentId,
    this.courseId,
    this.examId,
    required this.type,
    required this.value,
    this.coefficient = 1.0,
    this.publishedById,
    this.academicYearId,
    this.isPublished = false,
    this.createdAt,
    this.student,
    this.course,
    this.exam,
    this.publishedBy,
    this.academicYear,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id'],
      studentId: json['student'] is String ? json['student'] : json['student']?['_id'],
      courseId: json['course'] is String ? json['course'] : json['course']?['_id'],
      examId: json['exam'] is String ? json['exam'] : json['exam']?['_id'],
      type: json['type'] ?? 'DS',
      value: (json['value'] ?? 0).toDouble(),
      coefficient: (json['coefficient'] ?? 1.0).toDouble(),
      publishedById: json['publishedBy'] is String ? json['publishedBy'] : json['publishedBy']?['_id'],
      academicYearId: json['academicYear'] is String ? json['academicYear'] : json['academicYear']?['_id'],
      isPublished: json['isPublished'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      student: json['student'] is Map ? json['student'] : null,
      course: json['course'] is Map ? json['course'] : null,
      exam: json['exam'] is Map ? json['exam'] : null,
      publishedBy: json['publishedBy'] is Map ? json['publishedBy'] : null,
      academicYear: json['academicYear'] is Map ? json['academicYear'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (studentId != null) 'student': studentId,
      if (courseId != null) 'course': courseId,
      if (examId != null) 'exam': examId,
      'type': type,
      'value': value,
      'coefficient': coefficient,
      if (publishedById != null) 'publishedBy': publishedById,
      if (academicYearId != null) 'academicYear': academicYearId,
      'isPublished': isPublished,
    };
  }

  String get studentName => student?['name'] ?? 'N/A';
  String get courseName => course?['title'] ?? 'N/A';
  String get courseCode => course?['code'] ?? '';
  String get examTitle => exam?['title'] ?? '';
  String get publisherName => publishedBy?['name'] ?? 'N/A';
  String get className => student?['class']?['name'] ?? 'N/A';
  String get formattedDate => createdAt != null ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}' : 'N/A';
  
  // Backward compatibility properties for UI
  String get subject => courseName;
  String get date => formattedDate;
  double? get classAverage => null; // This would need to be calculated or passed separately
  
  // Status enum for backward compatibility (isPublished replaces it)
  NoteStatus get status => isPublished ? NoteStatus.publiee : NoteStatus.nonPubliee;
}

enum NoteStatus { publiee, nonPubliee }
