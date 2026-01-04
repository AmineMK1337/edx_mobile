class UploadRequest {
  final String title;
  final String subject;
  final String tag;
  final String description;
  final String teacher;

  UploadRequest({
    required this.title,
    required this.subject,
    required this.tag,
    this.description = "",
    this.teacher = "Étudiant",
  });

  // Convertit les données en format "champs" pour l'envoi Multipart
  Map<String, String> toFields() {
    return {
      'title': title,
      'subject': subject,
      'tag': tag,
      'description': description,
      'teacher': teacher,
    };
  }
}