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
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? 'Général',
    );
  }
}