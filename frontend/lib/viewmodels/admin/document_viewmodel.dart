import 'package:flutter/material.dart';
import '../../models/admin/document_model.dart';
import '../../services/api_service.dart';

class AdminDocumentViewModel extends ChangeNotifier {
  List<AdminDocument> _documents = [];
  bool _isLoading = false;
  String _selectedFilter = 'Tous';

  List<AdminDocument> get documents => _documents;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;

  int get pendingCount => _documents.where((d) => d.status == 'En attente').length;
  int get signedCount => _documents.where((d) => d.status == 'Signé').length;
  int get rejectedCount => _documents.where((d) => d.status == 'Rejeté').length;

  AdminDocumentViewModel() {
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/documents');
      if (response != null && response is List) {
        _documents = response.map((json) => AdminDocument.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback mock data
      _documents = [
        AdminDocument(id: '1', title: 'Attestation de scolarité', studentName: 'Ahmed Ben Ali', type: 'Scolarité', date: '2024-01-15', status: 'En attente'),
        AdminDocument(id: '2', title: 'Relevé de notes S1', studentName: 'Sami Trabelsi', type: 'Notes', date: '2024-01-14', status: 'Signé'),
        AdminDocument(id: '3', title: 'Convention de stage', studentName: 'Fatma Gharbi', type: 'Stage', date: '2024-01-13', status: 'Rejeté'),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<AdminDocument> getFilteredDocuments() {
    if (_selectedFilter == 'Tous') {
      return _documents;
    }
    return _documents.where((d) => d.status == _selectedFilter).toList();
  }

  Future<bool> approveDocument(String id) async {
    try {
      final response = await ApiService.put('/admin/documents/$id/approve', {});
      if (response != null) {
        await fetchDocuments();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<bool> rejectDocument(String id) async {
    try {
      final response = await ApiService.put('/admin/documents/$id/reject', {});
      if (response != null) {
        await fetchDocuments();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }
}
