import 'package:flutter/foundation.dart';
import '../../models/student/ticket_e_model.dart';
import '../../services/api_service.dart';

class TicketViewModel extends ChangeNotifier {
  List<TicketModel> _tickets = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

  List<TicketModel> get tickets => _tickets;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  final List<Map<String, String>> documentTypes = [
    {'value': 'attestation_presence', 'label': 'Attestation de présence'},
    {'value': 'attestation_reussite', 'label': 'Attestation de réussite'},
    {'value': 'releve_notes', 'label': 'Relevé de notes'},
    {'value': 'attestation_niveau_langue', 'label': 'Attestation niveau de langue'},
    {'value': 'bulletin', 'label': 'Bulletin'},
    {'value': 'autre', 'label': 'Autre'},
  ];

  Future<void> fetchTickets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/tickets/my', requiresAuth: true);

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }

      _tickets = data.map((json) => TicketModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur TicketViewModel: $e");
      _error = "Erreur lors du chargement des tickets";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDocumentRequest({
    required String documentType,
    required String subject,
    required String message,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/tickets', {
        'ticketType': 'document_request',
        'documentType': documentType,
        'subject': subject,
        'message': message,
      }, requiresAuth: true);

      if (response != null) {
        await fetchTickets();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur création ticket: $e");
      _error = "Erreur lors de la création du ticket";
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> createExamReviewRequest({
    required String courseName,
    required double currentMark,
    required String subject,
    required String message,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/tickets', {
        'ticketType': 'exam_review',
        'courseName': courseName,
        'currentMark': currentMark,
        'subject': subject,
        'message': message,
      }, requiresAuth: true);

      if (response != null) {
        await fetchTickets();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur création ticket: $e");
      _error = "Erreur lors de la création du ticket";
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> cancelTicket(String ticketId) async {
    try {
      await ApiService.delete('/tickets/$ticketId', requiresAuth: true);
      await fetchTickets();
      return true;
    } catch (e) {
      debugPrint("Erreur annulation ticket: $e");
      _error = "Erreur lors de l'annulation du ticket";
      notifyListeners();
      return false;
    }
  }
}
