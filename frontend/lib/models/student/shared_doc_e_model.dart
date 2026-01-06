class SharedDocModel {
  final String id;
  final String title;
  final String teacher;
  final String date;
  final String description;
  final String tag;
  final String note;
  final String views;
  final String? fileUrl;

  SharedDocModel({
    required this.id,
    required this.title,
    required this.teacher,
    required this.date,
    required this.description,
    required this.tag,
    required this.note,
    required this.views,
    this.fileUrl,
  });

  factory SharedDocModel.fromJson(Map<String, dynamic> json) {
    return SharedDocModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? "Sans titre",
      teacher: json['teacher'] ?? "Inconnu",
      date: json['date'] ?? "--/--/--",
      description: json['description'] ?? "",
      tag: json['tag'] ?? "Autre",
      note: json['note']?.toString() ?? "Nouveau",
      views: json['views']?.toString() ?? "0",
      fileUrl: json['fileUrl'],
    );
  }
}