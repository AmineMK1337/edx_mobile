class DocumentModel {
  final String? id;
  final String title;
  final String? description;
  final String? courseId;
  final String fileUrl;
  final String fileType; // pdf, doc, image, etc
  final DateTime uploadedDate;
  final String? uploadedById;
  final int downloads;

  // Populated fields
  final Map<String, dynamic>? course;
  final Map<String, dynamic>? uploadedBy;

  DocumentModel({
    this.id,
    required this.title,
    this.description,
    this.courseId,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedDate,
    this.uploadedById,
    this.downloads = 0,
    this.course,
    this.uploadedBy,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['_id'],
      title: json['title'] ?? 'Document',
      description: json['description'],
      courseId: json['course'] is String ? json['course'] : json['course']?['_id'],
      fileUrl: json['fileUrl'] ?? '',
      fileType: json['fileType'] ?? 'pdf',
      uploadedDate: DateTime.parse(json['uploadedDate'] ?? DateTime.now().toIso8601String()),
      uploadedById: json['uploadedBy'] is String ? json['uploadedBy'] : json['uploadedBy']?['_id'],
      downloads: json['downloads'] ?? 0,
      course: json['course'] is Map ? json['course'] : null,
      uploadedBy: json['uploadedBy'] is Map ? json['uploadedBy'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      if (description != null) 'description': description,
      if (courseId != null) 'course': courseId,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'uploadedDate': uploadedDate.toIso8601String(),
      if (uploadedById != null) 'uploadedBy': uploadedById,
      'downloads': downloads,
    };
  }

  String get courseName => course?['title'] ?? 'N/A';
  String get uploaderName => uploadedBy?['name'] ?? 'N/A';
  String get formattedDate => '${uploadedDate.day}/${uploadedDate.month}/${uploadedDate.year}';
}
