import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/upload_request_e_model.dart';
import '../services/api_service.dart';

class PartagerViewModel extends ChangeNotifier {
  bool _isSubmitting = false;
  FilePickerResult? _pickerResult;
  String? _fileName;

  bool get isSubmitting => _isSubmitting;
  String? get fileName => _fileName;
  
  final List<String> types = ["Cours", "TD", "TP", "Examen", "Rapport"];
  final List<String> subjects = ["Programmation C", "Analyse", "Algorithmique", "Réseaux", "Systèmes", "Maths", "Anglais"];
  final List<String> classes = [
    "INDP1A", "INDP1B", "INDP1C", "INDP1D", "INDP1E", "INDP1F",
    "INDP2A", "INDP2B", "INDP2C", "INDP2D", "INDP2E", "INDP2F",
    "INDP3A", "INDP3B", "INDP3C", "INDP3D", "INDP3E", "INDP3F"
  ];

  // Sélectionner le fichier
  Future<void> pickFile() async {
    try {
      _pickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
        withData: true,
      );
      if (_pickerResult != null) {
        _fileName = _pickerResult!.files.single.name;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur sélection fichier: $e");
    }
  }

  // Envoyer au serveur
  Future<bool> uploadDocument(UploadRequest data) async {
    if (_pickerResult == null) return false;
    _isSubmitting = true;
    notifyListeners();

    try {
      final baseUrl = ApiService.baseUrl.replaceAll('/api', '');
      final token = ApiService.getToken();
      
      debugPrint("Upload baseUrl: $baseUrl");
      debugPrint("Token available: ${token != null}");
      debugPrint("Title: ${data.title}");
      debugPrint("Target Class: ${data.targetClass}");
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/shared-docs'));
      
      // Add authorization header
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // Add form fields
      request.fields['title'] = data.title;
      request.fields['targetClass'] = data.targetClass;
      request.fields['description'] = data.description;
      request.fields['teacher'] = data.teacher;

      // Add file
      var file = _pickerResult!.files.single;
      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes('pdfFile', file.bytes!, filename: file.name));
      } else {
        request.files.add(await http.MultipartFile.fromPath('pdfFile', file.path!));
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      debugPrint("Upload response status: ${response.statusCode}");
      debugPrint("Upload response body: $responseBody");
      
      if (response.statusCode != 201) {
        debugPrint("Erreur upload: Status ${response.statusCode}");
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint("Erreur upload: $e");
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}