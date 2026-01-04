import 'package:flutter/material.dart';

class VoirDocumentViewModel extends ChangeNotifier {
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Future<void> downloadFile(String documentId) async {
    _isDownloading = true;
    notifyListeners();

    try {
      // Simuler un délai de téléchargement
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Téléchargement du document : $documentId");
    } catch (e) {
      debugPrint("Erreur de téléchargement : $e");
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }
}