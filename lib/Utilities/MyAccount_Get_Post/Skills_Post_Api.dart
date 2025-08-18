import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ApiConstants.dart';

class SkillsPostApi {
  static Future<bool> updateSkills({
    required String authToken,
    required String connectSid,
    required List<String> skills,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}profile/student/update-skills',
      );

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };

      final body = jsonEncode({
        "skills": skills.join(", "),
      });

      print("📤 Sending POST request to update skills...");
      print("👉 URL: $uri");
      print("👉 Headers: $headers");
      print("👉 Body: $body");

      final request = http.Request('POST', uri)
        ..headers.addAll(headers)
        ..body = body;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("📩 Received response (${response.statusCode}): $responseBody");

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        print("✅ Skills update status: ${decoded['status']}");
        return decoded['status'] == true;
      } else {
        print('❌ Skills POST failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Skills POST error: $e');
      return false;
    }
  }
}
