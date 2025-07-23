import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/InterviewScreen_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterviewApi {
  static Future<List<InterviewModel>> fetchInterviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final connectSid = prefs.getString('connectSid') ?? '';
      var url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/interview-room/list');
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };
      var request = http.Request('POST', url);
      request.body = json.encode({
        "job_id": "",
        "from_date": "",
        "to_date": "",
        "from": "",
        "interviewTitle": "",
        "sort": ""
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final jsonData = json.decode(body);
        final List<dynamic> data = jsonData['scheduled_meeting_list'];
        return data.map((item) => InterviewModel.fromJson(item)).toList();
      } else {
        print(' Failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(' Error fetching interview list: $e');
      return [];
    }
  }
}
