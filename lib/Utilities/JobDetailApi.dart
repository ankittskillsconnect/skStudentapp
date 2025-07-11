import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobDetailApi {
  static Future<Map<String, dynamic>> fetchJobDetail({required String token}) async {
    if (token.isEmpty) {
      throw Exception('Job token is missing.');
    }

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
    };

    final body = jsonEncode({
      "job_id": "",
      "slug": "",
      "token": token,
    });

    final response = await http.post(
      Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/jobs/details'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        if (data['status'] == true && data['job'] != null && data['job'] is Map) {
          return data['job'] as Map<String, dynamic>;
        } else {
          throw Exception('API responded with status false or job is null. Message: ${data['msg']}');
        }
      } catch (e) {
        throw Exception('Failed to parse response: $e');
      }
    } else {
      throw Exception('Failed to fetch Job Details: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
