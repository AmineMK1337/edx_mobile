import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/doc_request_e_model.dart';

class DemandeDocViewModel extends ChangeNotifier {
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  final List<String> documentTypes = [
    'Attestation de Scolarité',
    'Relevé de Notes',
    'Certificat de Stage',
    'Autre'
  ];

  String getBaseUrl() {
    const String serverIP = "192.168.100.17";
    const String port = "5000";
    if (kIsWeb) return 'http://localhost:$port';
    return 'http://$serverIP:$port';
  }

  Future<bool> submitRequest(DocRequest request) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final url = Uri.parse('${getBaseUrl()}/api/doc-requests/send');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Erreur soumission: $e");
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}