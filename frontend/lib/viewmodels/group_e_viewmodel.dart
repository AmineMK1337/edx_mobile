import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/group_member_e_model.dart';

class GroupViewModel extends ChangeNotifier {
  List<GroupMember> _groupList = [];
  bool _isLoading = true;

  List<GroupMember> get groupList => _groupList;
  bool get isLoading => _isLoading;

  String get _baseUrl => kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  Future<void> fetchGroup() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/groups'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _groupList = data.map((json) => GroupMember.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Erreur GroupViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}