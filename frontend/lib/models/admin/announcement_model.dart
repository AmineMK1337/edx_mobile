class AdminAnnouncement {
  final String id;
  final String title;
  final String date;
  final String audience; // "Tous", "Étudiants", "Profs"
  final String status;   // "Publié", "Brouillon", "Programmé"
  final int views;

  AdminAnnouncement({
    required this.id,
    required this.title,
    required this.date,
    required this.audience,
    required this.status,
    required this.views,
  });

  factory AdminAnnouncement.fromJson(Map<String, dynamic> json) {
    return AdminAnnouncement(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? json['createdAt'] ?? '',
      audience: json['audience'] ?? 'Tous',
      status: json['status'] ?? 'Brouillon',
      views: json['views'] ?? 0,
    );
  }
}
