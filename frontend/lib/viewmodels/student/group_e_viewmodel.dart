import 'package:flutter/material.dart';
import '../../models/student/group_member_e_model.dart';
import '../../services/api_service.dart';

class GroupViewModel extends ChangeNotifier {
  List<GroupMember> _groupList = [];
  bool _isLoading = true;

  List<GroupMember> get groupList => _groupList;
  bool get isLoading => _isLoading;

  Future<void> fetchGroup() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/classes', requiresAuth: true);

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map && response.containsKey('data')) {
        data = response['data'];
      }
      
      _groupList = data.map((json) => GroupMember.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur GroupViewModel : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}