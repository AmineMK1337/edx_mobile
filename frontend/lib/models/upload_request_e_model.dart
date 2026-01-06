class UploadRequest {
  final String title;
  final String targetClass;
  final String description;
  final String teacher;

  UploadRequest({
    required this.title,
    required this.targetClass,
    this.description = "",
    this.teacher = "Professeur",
  });

  // Convertit les données en format "champs" pour l'envoi Multipart
  Map<String, String> toFields() {
    return {
      'title': title,
      'targetClass': targetClass,
      'description': description,
      'teacher': teacher,
    };
  }
}