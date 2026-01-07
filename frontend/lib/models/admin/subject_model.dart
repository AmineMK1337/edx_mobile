class AdminSubject {
  final String id;
  final String name;
  final String code;
  final String professor;
  final double coeff;
  final int semester;
  final String type; // Cours, TD, TP

  AdminSubject({
    required this.id,
    required this.name,
    required this.code,
    required this.professor,
    required this.coeff,
    required this.semester,
    required this.type,
  });

  factory AdminSubject.fromJson(Map<String, dynamic> json) {
    return AdminSubject(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      professor: json['professor'] ?? '',
      coeff: (json['coeff'] ?? 1.0).toDouble(),
      semester: json['semester'] ?? 1,
      type: json['type'] ?? 'Cours',
    );
  }
}
