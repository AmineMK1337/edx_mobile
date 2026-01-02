import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../services/api_service.dart';

class DocumentsViewModel extends ChangeNotifier {
  List<DocumentModel> documents = [];
  bool isLoading = false;
  String? error;
  String? courseId;

  DocumentsViewModel({this.courseId}) {
    if (courseId != null) {
      fetchDocuments();
    }
  }

  Future<void> fetchDocuments() async {
    if (courseId == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      print('Fetching documents for course: $courseId');
      print('Token available: ${ApiService.getToken() != null}');
      
      final response = await ApiService.get('/documents/course/$courseId', requiresAuth: true);

      print('Response type: ${response.runtimeType}');
      print('Response: $response');

      if (response is List) {
        documents = response
            .whereType<Map>()
            .map((data) => DocumentModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else if (response is Map && response['data'] is List) {
        documents = (response['data'] as List)
            .whereType<Map>()
            .map((data) => DocumentModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        documents = [];
      }
      
      print('Documents loaded: ${documents.length}');
      error = null;
    } catch (e) {
      print('Error fetching documents: $e');
      error = 'Impossible de charger les documents: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadDocument(DocumentModel document) async {
    try {
      // In a real app, you would download the file here
      // For now, just increment download count and show success message
      print('Downloading: ${document.title}');
      // Could use url_launcher to open the file
      // await launchUrl(Uri.parse(document.fileUrl));
    } catch (e) {
      error = 'Erreur lors du téléchargement: $e';
      notifyListeners();
    }
  }
}
