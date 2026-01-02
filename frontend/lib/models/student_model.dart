enum StudentAttendanceStatus { present, absent, late, justified }

class StudentModel {
  final String id;
  final String name;
  final String email;
  final String matricule;
  final String? classId;
  final Map<String, dynamic>? classDetails;
  StudentAttendanceStatus status;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.matricule,
    this.classId,
    this.classDetails,
    this.status = StudentAttendanceStatus.present,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      matricule: json['matricule'] ?? 'N/A',
      classId: json['class'] is String ? json['class'] : json['class']?['_id'],
      classDetails: json['class'] is Map ? json['class'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'matricule': matricule,
      if (classId != null) 'class': classId,
    };
  }

  String get className => classDetails?['name'] ?? 'N/A';
}
