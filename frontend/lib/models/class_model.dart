class ClassModel {
  final String? id;
  final String name;
  final String level;
  final String section;
  final String academicYear;
  final int studentCount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClassModel({
    this.id,
    required this.name,
    required this.level,
    required this.section,
    required this.academicYear,
    this.studentCount = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'],
      name: json['name'],
      level: json['level'],
      section: json['section'],
      academicYear: json['academicYear'] is String 
          ? json['academicYear']
          : json['academicYear']?['_id'],
      studentCount: json['studentCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'level': level,
      'section': section,
      'academicYear': academicYear,
      'studentCount': studentCount,
      'isActive': isActive,
    };
  }
}
