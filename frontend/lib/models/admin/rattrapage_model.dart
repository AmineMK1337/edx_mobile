class RattrapageSession {
  final String id;
  final String subject;
  final String professor;
  final String date;
  final String time;
  final String room;
  final int registered;
  final int capacity;

  RattrapageSession({
    required this.id,
    required this.subject,
    required this.professor,
    required this.date,
    required this.time,
    required this.room,
    required this.registered,
    required this.capacity,
  });

  double get progress => capacity == 0 ? 0 : registered / capacity;

  factory RattrapageSession.fromJson(Map<String, dynamic> json) {
    return RattrapageSession(
      id: json['_id'] ?? json['id'] ?? '',
      subject: json['subject'] ?? '',
      professor: json['professor'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      room: json['room'] ?? '',
      registered: json['registered'] ?? 0,
      capacity: json['capacity'] ?? 30,
    );
  }
}
