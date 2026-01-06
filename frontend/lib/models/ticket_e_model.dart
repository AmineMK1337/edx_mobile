class TicketModel {
  final String id;
  final String ticketType;
  final String? documentType;
  final String? examId;
  final String? courseName;
  final double? currentMark;
  final String subject;
  final String message;
  final String? response;
  final String status;
  final String createdAt;
  final String? answeredBy;

  TicketModel({
    required this.id,
    required this.ticketType,
    this.documentType,
    this.examId,
    this.courseName,
    this.currentMark,
    required this.subject,
    required this.message,
    this.response,
    required this.status,
    required this.createdAt,
    this.answeredBy,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    String dateStr = "";
    if (json['createdAt'] != null) {
      try {
        final date = DateTime.parse(json['createdAt']);
        dateStr = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (_) {
        dateStr = json['createdAt'] ?? "";
      }
    }

    return TicketModel(
      id: json['_id'] ?? '',
      ticketType: json['ticketType'] ?? '',
      documentType: json['documentType'],
      examId: json['examId']?['_id'] ?? json['examId'],
      courseName: json['courseName'],
      currentMark: json['currentMark']?.toDouble(),
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      response: json['response'],
      status: json['status'] ?? 'pending',
      createdAt: dateStr,
      answeredBy: json['answeredBy']?['name'] ?? json['answeredBy'],
    );
  }

  String get statusLabel {
    switch (status) {
      case 'pending': return 'En attente';
      case 'in_progress': return 'En cours';
      case 'approved': return 'Approuvé';
      case 'rejected': return 'Rejeté';
      case 'closed': return 'Fermé';
      default: return status;
    }
  }

  String get ticketTypeLabel {
    switch (ticketType) {
      case 'document_request': return 'Demande de document';
      case 'exam_review': return 'Révision de copie';
      default: return ticketType;
    }
  }

  String get documentTypeLabel {
    switch (documentType) {
      case 'attestation_presence': return 'Attestation de présence';
      case 'attestation_reussite': return 'Attestation de réussite';
      case 'releve_notes': return 'Relevé de notes';
      case 'attestation_niveau_langue': return 'Attestation niveau de langue';
      case 'bulletin': return 'Bulletin';
      case 'autre': return 'Autre';
      default: return documentType ?? '';
    }
  }
}
