class AdminDocument {
  final String id;
  final String title;
  final String studentName;
  final String type;
  final String date;
  final String status; // En attente, Signé, Rejeté

  AdminDocument({
    required this.id,
    required this.title,
    required this.studentName,
    required this.type,
    required this.date,
    required this.status,
  });

  factory AdminDocument.fromJson(Map<String, dynamic> json) {
    return AdminDocument(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      studentName: json['studentName'] ?? json['requestedBy']?['name'] ?? '',
      type: json['type'] ?? 'Scolarité',
      date: json['date'] ?? json['createdAt'] ?? '',
      status: json['status'] ?? 'En attente',
    );
  }
}
