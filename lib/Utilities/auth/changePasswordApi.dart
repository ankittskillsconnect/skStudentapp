import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ApiConstants.dart';

class PasswordServices {
  static const String _baseurl =
      "${ApiConstants.baseUrl}authenticate/change-password";

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseurl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "otp": int.tryParse(otp),
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password reset successful'};
      } else {
        final body = json.decode(response.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Unknown error',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception occurred: $e'};
    }
  }
}
