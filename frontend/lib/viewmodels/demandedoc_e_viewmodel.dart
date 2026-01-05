import 'package:flutter/foundation.dart';
import '../models/doc_request_e_model.dart';
import '../services/api_service.dart';

class DemandeDocViewModel extends ChangeNotifier {
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<String> documentTypes = [
    'Attestation de Scolarité',
    'Relevé de Notes',
    'Certificat de Stage',
    'Autre'
  ];

  Future<bool> submitRequest(DocRequest request) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        '/doc-requests/send',
        request.toJson(),
        requiresAuth: false, // Document request submission doesn't require auth
      );

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Erreur soumission: $e";
      debugPrint(_errorMessage);
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}