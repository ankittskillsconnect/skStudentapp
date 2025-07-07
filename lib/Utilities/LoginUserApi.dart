import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class loginUser {
  static const String _loginUrl =
      'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/authenticate/login';
  static const String _tokenKey = 'auth_token';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final headers = {'Content-Type': 'application/json'};
    final requestBody = json.encode({
      "username": username.trim(),
      "password": password,
      "LoginOTP": "",
    });

    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: headers,
        body: requestBody,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['token'];

        if (token != null && token is String) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          return {
            'success': true,
            'message': 'Login successful',
            'token': token,
          };
        } else {
          return {'success': false, 'message': 'Token not found in response'};
        }
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
