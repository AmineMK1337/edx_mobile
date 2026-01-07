class SchoolDocument {
  final String id;
  final String title;
  final String category;
  final String fileType;
  final String fileSize;
  final String date;
  final String author;      
  final String description; 

  SchoolDocument({
    required this.id,
    required this.title,
    required this.category,
    required this.fileType,
    required this.fileSize,
    required this.date,
    this.author = "Administration",
    this.description = "Aucune description disponible pour ce document.",
  });

  factory SchoolDocument.fromJson(Map<String, dynamic> json) {
    return SchoolDocument(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'] ?? '',
      date: json['date'] ?? '',
      author: json['author'] ?? 'Administration',
      description: json['description'] ?? 'Aucune description disponible.',
    );
  }
}
