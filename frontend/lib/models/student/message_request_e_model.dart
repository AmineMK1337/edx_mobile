class MessageRequest {
  final String role;
  final String specificName;
  final String subject;
  final String content;

  MessageRequest({
    required this.role,
    this.specificName = "",
    required this.subject,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      "destinataire": role,
      "specificName": specificName,
      "objet": subject,
      "contenu": content,
    };
  }
}
