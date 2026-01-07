import 'common/class_model.dart';
import 'user_model.dart';

class TimetableModel {
  final String id;
  final String title;
  final String description;
  final ClassModel classRef;
  final String academicYear;
  final String semester;
  final String pdfFileName;
  final String pdfFilePath;
  final int fileSize;
  final int downloadCount;
  final UserModel? uploadedBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimetableModel({
    required this.id,
    required this.title,
    required this.description,
    required this.classRef,
    required this.academicYear,
    required this.semester,
    required this.pdfFileName,
    required this.pdfFilePath,
    required this.fileSize,
    required this.downloadCount,
    this.uploadedBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      classRef: ClassModel.fromJson(json['class'] ?? {}),
      academicYear: json['academicYear'] ?? '',
      semester: json['semester'] ?? '',
      pdfFileName: json['pdfFileName'] ?? '',
      pdfFilePath: json['pdfFilePath'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      downloadCount: json['downloadCount'] ?? 0,
      uploadedBy: json['uploadedBy'] != null 
          ? UserModel.fromJson(json['uploadedBy'])
          : null,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'class': classRef.toJson(),
      'academicYear': academicYear,
      'semester': semester,
      'pdfFileName': pdfFileName,
      'pdfFilePath': pdfFilePath,
      'fileSize': fileSize,
      'downloadCount': downloadCount,
      'uploadedBy': uploadedBy?.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get semesterDisplay {
    switch (semester) {
      case 'S1':
        return 'Semester 1';
      case 'S2':
        return 'Semester 2';
      default:
        return semester;
    }
  }
}
