class AdminTicket {
  final String id;
  final String title;
  final String userName;
  final String category;
  final String date;
  final String priority; // haute, moyenne, basse
  final String status;   // nouveau, en cours, resolu

  AdminTicket({
    required this.id,
    required this.title,
    required this.userName,
    required this.category,
    required this.date,
    required this.priority,
    required this.status,
  });

  factory AdminTicket.fromJson(Map<String, dynamic> json) {
    return AdminTicket(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['subject'] ?? '',
      userName: json['userName'] ?? json['createdBy']?['name'] ?? '',
      category: json['category'] ?? 'Général',
      date: json['date'] ?? json['createdAt'] ?? '',
      priority: json['priority'] ?? 'moyenne',
      status: json['status'] ?? 'nouveau',
    );
  }
}
