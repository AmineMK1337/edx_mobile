import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/upload_request_e_model.dart';

class PartagerViewModel extends ChangeNotifier {
  bool _isSubmitting = false;
  FilePickerResult? _pickerResult;
  String? _fileName;

  bool get isSubmitting => _isSubmitting;
  String? get fileName => _fileName;
  
  final List<String> types = ["Cours", "TD", "TP", "Examen", "Rapport"];
  final List<String> subjects = ["Programmation C", "Analyse", "Algorithmique", "Réseaux", "Systèmes", "Maths", "Anglais"];

  // Sélectionner le fichier PDF
  Future<void> pickFile() async {
    try {
      _pickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
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
      const String serverIP = "192.168.100.17";
      final baseUrl = kIsWeb ? 'http://localhost:5000' : 'http://$serverIP:5000';
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/shared-docs'));
      request.fields.addAll(data.toFields());

      var file = _pickerResult!.files.single;
      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes('pdfFile', file.bytes!, filename: file.name));
      } else {
        request.files.add(await http.MultipartFile.fromPath('pdfFile', file.path!));
      }

      var response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Erreur upload: $e");
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}