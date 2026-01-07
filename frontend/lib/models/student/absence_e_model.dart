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
    // Extract course title
    final courseData = json['course'];
    final subject = courseData is Map ? courseData['title'] ?? 'Unknown' : 'Unknown';
    
    // Extract session type
    final sessionType = json['sessionType'] ?? 'course';
    
    // Extract date and format it
    final dateStr = json['date'] ?? '';
    String formattedDate = '';
    String formattedTime = '';
    if (dateStr.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(dateStr.toString());
        formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
        formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        formattedDate = dateStr;
        formattedTime = '';
      }
    }
    
    // Check if justified (status is 'justified')
    final status = json['status'] ?? 'absent';
    final isJustified = status == 'justified';

    return Absence(
      id: json['_id'] ?? '',
      subject: subject,
      type: sessionType,
      time: formattedTime,
      date: formattedDate,
      isJustified: isJustified,
    );
  }

  String get formattedDetails => "$type - $time | $date";
}
