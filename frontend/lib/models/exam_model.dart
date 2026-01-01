enum ExamStatus { planifie, passe }

class ExamModel {
  final String title;
  final String subject;
  final ExamStatus status;
  final String date;
  final String time;
  final String className;
  final int studentCount;
  final String duration;
  final String location;

  ExamModel({
    required this.title,
    required this.subject,
    required this.status,
    required this.date,
    required this.time,
    required this.className,
    required this.studentCount,
    required this.duration,
    required this.location,
  });
}