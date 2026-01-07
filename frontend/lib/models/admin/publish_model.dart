class ExamSession {
  final String id;
  final String subject;
  final String type;
  final String group;
  final String professor;
  final String date;
  final int studentCount;
  final bool isReady;

  ExamSession({
    required this.id,
    required this.subject,
    required this.type,
    required this.group,
    required this.professor,
    required this.date,
    required this.studentCount,
    this.isReady = true,
  });

  factory ExamSession.fromJson(Map<String, dynamic> json) {
    return ExamSession(
      id: json['_id'] ?? json['id'] ?? '',
      subject: json['subject'] ?? '',
      type: json['type'] ?? 'Examen',
      group: json['group'] ?? '',
      professor: json['professor'] ?? '',
      date: json['date'] ?? '',
      studentCount: json['studentCount'] ?? 0,
      isReady: json['isReady'] ?? true,
    );
  }
}
