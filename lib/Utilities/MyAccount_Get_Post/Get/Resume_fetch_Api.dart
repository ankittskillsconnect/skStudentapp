import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/Resume_fetch_Model.dart';

class ResumeFetchApi {
  static Future<ResumeModel?> fetchResume() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    final headers = {
      'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
    };

    final request = http.Request(
      'GET',
      Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/resume'),
    );

    request.headers.addAll(headers);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final jsonString = await response.stream.bytesToString();
        final jsonMap = json.decode(jsonString);

        final resumeUrl = jsonMap['resume'];
        if (resumeUrl != null && resumeUrl.toString().startsWith('http')) {
          return ResumeModel(resume: resumeUrl);
        }
      } else {
        print('❌ Resume fetch failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Resume fetch error: $e');
    }
    return null;
  }
}
