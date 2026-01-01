import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const Duration timeout = Duration(seconds: 30);
  static String? _token;

  // GET Request
  static Future<dynamic> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      if (requiresAuth && _token != null) {
        headers['Authorization'] = 'Bearer $_token';
      }

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // POST Request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data, {bool requiresAuth = false}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      if (requiresAuth && _token != null) {
        headers['Authorization'] = 'Bearer $_token';
      }

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // PUT Request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data, {bool requiresAuth = false}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      if (requiresAuth && _token != null) {
        headers['Authorization'] = 'Bearer $_token';
      }

      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // DELETE Request
  static Future<dynamic> delete(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      if (requiresAuth && _token != null) {
        headers['Authorization'] = 'Bearer $_token';
      }

      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Auth methods
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await post('/auth/login', {
      'email': email,
      'password': password,
    });
    if (response['token'] != null) {
      _token = response['token'];
    }
    return response;
  }

  static Future<void> logout() async {
    _token = null;
  }

  static String? getToken() {
    return _token;
  }
}


