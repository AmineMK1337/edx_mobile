class AcademicYearModel {
  final String? id;
  final String year;
  final String semester;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AcademicYearModel({
    this.id,
    required this.year,
    required this.semester,
    required this.startDate,
    required this.endDate,
    this.isCurrent = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AcademicYearModel.fromJson(Map<String, dynamic> json) {
    return AcademicYearModel(
      id: json['_id'],
      year: json['year'],
      semester: json['semester'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCurrent: json['isCurrent'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'year': year,
      'semester': semester,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCurrent': isCurrent,
    };
  }

  String get displayName => '$year - Semester $semester';
}
