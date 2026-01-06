class StudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? studentClass;
  

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.studentClass,
    
  });

  // Pour transformer le JSON de l'API en objet Dart
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      photoUrl: json['photoUrl'],
      studentClass: json['studentClass'],
      
    );
  }
}