class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;    // Étudiant, Professeur, Administrateur
  final String details; // Ex: "2A - RT" ou "Réseaux"
  final String status;  // actif, inactif

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.details,
    required this.status,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Étudiant',
      details: json['details'] ?? json['class'] ?? '',
      status: json['isActive'] == true ? 'Actif' : 'Inactif',
    );
  }
}
