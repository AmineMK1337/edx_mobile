import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const Duration timeout = Duration(seconds: 30);
  static String? _token;
  static Map<String, dynamic>? _currentUser;

  // GET Request
  static Future<dynamic> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      if (requiresAuth) {
        if (_token == null) {
          throw Exception('Token manquant - veuillez vous reconnecter');
        }
        headers['Authorization'] = 'Bearer $_token';
      }

      print('GET $baseUrl$endpoint');
      if (requiresAuth) {
        print('Token: ${_token?.substring(0, 20)}...');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeout);

      print('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error response: ${response.body}');
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API GET Error: $e');
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
    print('Login attempt for: $email');
    final response = await post('/auth/login', {
      'email': email,
      'password': password,
    });
    if (response['token'] != null) {
      _token = response['token'];
      print('Token saved: ${_token?.substring(0, 20)}...');
    } else {
      print('No token in response!');
    }
    // Store user data
    if (response['user'] != null) {
      _currentUser = Map<String, dynamic>.from(response['user']);
      print('User saved: ${_currentUser?['name']}');
    }
    return response;
  }

  static Future<void> logout() async {
    _token = null;
    _currentUser = null;
  }

  static String? getToken() {
    return _token;
  }

  static Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  static String getUserName() {
    return _currentUser?['name'] ?? 'Utilisateur';
  }

  static String getUserRole() {
    return _currentUser?['role'] ?? '';
  }

  // Forgot Password - Request reset code
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await post('/auth/forgot-password', {'email': email});
      return {'success': true, 'message': response['message'] ?? 'Code envoyé'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Verify Reset Code
  static Future<Map<String, dynamic>> verifyResetCode(String email, String code) async {
    try {
      final response = await post('/auth/verify-reset-code', {
        'email': email,
        'code': code,
      });
      return {'success': true, 'message': response['message'] ?? 'Code vérifié'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Reset Password
  static Future<Map<String, dynamic>> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await post('/auth/reset-password', {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      });
      return {'success': true, 'message': response['message'] ?? 'Mot de passe réinitialisé'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}


