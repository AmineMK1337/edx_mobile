class Absence {
  final String id;
  final String subject;
  final String type;
  final String time;
  final String date;
  final bool isJustified;

  Absence({
    required this.id,
    required this.subject,
    required this.type,
    required this.time,
    required this.date,
    required this.isJustified,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['_id'] ?? '',
      subject: json['subject'] ?? '',
      type: json['type'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      isJustified: json['isJustified'] ?? false,
    );
  }

  String get formattedDetails => "$type - $time | $date";
}