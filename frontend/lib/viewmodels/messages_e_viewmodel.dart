import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/message_e_model.dart';

class MessagesViewModel extends ChangeNotifier {
  List<AppMessage> _messagesList = [];
  bool _isLoading = true;

  List<AppMessage> get messagesList => _messagesList;
  bool get isLoading => _isLoading;

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/messages'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _messagesList = data.map((json) => AppMessage.fromJson(json)).toList();
      } else {
        debugPrint("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erreur MessagesViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}