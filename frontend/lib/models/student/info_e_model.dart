class InfoNote {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category;

  InfoNote({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });

  factory InfoNote.fromJson(Map<String, dynamic> json) {
    return InfoNote(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['content'] ?? json['description'] ?? '',
      date: json['createdAt'] != null ? json['createdAt'].toString().split('T')[0] : '',
      category: json['priority'] != null ? _mapPriority(json['priority']) : 'Général',
    );
  }

  static String _mapPriority(String priority) {
    switch (priority) {
      case 'high':
        return 'Important';
      case 'medium':
        return 'Général';
      case 'low':
        return 'Info';
      default:
        return 'Général';
    }
  }
}
