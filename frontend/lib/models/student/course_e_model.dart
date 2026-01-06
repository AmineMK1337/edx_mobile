class Course {
  final String id;
  final String day;
  final String time;
  final String subject;
  final String type;
  final String professor;
  final String room;

  Course({
    required this.id,
    required this.day,
    required this.time,
    required this.subject,
    required this.type,
    required this.professor,
    required this.room,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      subject: json['subject'] ?? '',
      type: json['type'] ?? '',
      professor: json['professor'] ?? '',
      room: json['room'] ?? '',
    );
  }
}