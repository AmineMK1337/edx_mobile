
class DocRequest {
  final String studentId;
  final String studentName;
  final String documentType;
  final String comment;

  DocRequest({
    required this.studentId,
    required this.studentName,
    required this.documentType,
    required this.comment,
  });

  // Convertit l'objet en JSON pour l'envoi API
  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "studentName": studentName,
      "documentType": documentType,
      "comment": comment,
    };
  }
}
