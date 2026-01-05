class UploadRequest {
  final String title;
  final String targetClass;
  final String description;
  final String subject;
  final String tag;
  final String teacher;

  UploadRequest({
    required this.title,
    this.targetClass = "",
    this.description = "",
    this.subject = "",
    this.tag = "",
    this.teacher = "Professeur",
  });

  // Convertit les données en format "champs" pour l'envoi Multipart
  Map<String, String> toFields() {
    return {
      'title': title,
      'targetClass': targetClass,
      'description': description,
      'subject': subject,
      'tag': tag,
      'teacher': teacher,
    };
  }
}