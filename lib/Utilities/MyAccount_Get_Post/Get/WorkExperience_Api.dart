import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sk_loginscreen1/Model/WorkExperience_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkExperienceApi {
  static Future<List<WorkExperienceModel>> fetchWorkExperienceApi({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      var url = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/work-experience-details',
      );
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };
      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String jsonString = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(jsonString);

        final List<dynamic> workExperienceList = data['workExperience'] ?? [];
        return workExperienceList
            .map((e) => WorkExperienceModel.fromJson(e))
            .toList();
      }else {
        throw Exception('Failed to load education details');
      }
    } catch (e) {
      print('❌ Error in EducationDetailApi: $e');
      return [];
    }
  }

  static Future<bool> saveWorkExperience({
    required WorkExperienceModel model,
    required String authToken,
    required String connectSid,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAuthToken = prefs.getString('authToken') ?? '';
      final savedConnectSid = prefs.getString('connectSid') ?? '';

      print("📦 [saveWorkExperience] Starting API call...");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $savedAuthToken',
        'Cookie': 'connect.sid=$savedConnectSid',
      };

      final body = jsonEncode(model.toJson());
      print("📤 [saveWorkExperience] Request Body: $body");

      final url = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-student-work-experience',
      );

      final response = await http.post(url, headers: headers, body: body);

      print("📥 [saveWorkExperience] Status Code: ${response.statusCode}");
      print("📥 [saveWorkExperience] Response Body: ${response.body}");
      print("📤 Final POST body: ${body}");


      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("✅ [saveWorkExperience] Work Experience Saved: ${decoded['msg']}");
        return true;
      } else {
        print("❌ [saveWorkExperience] Failed to save. Details:");
        print("Headers: $headers");
        print("Body Sent: $body");
        print("Response Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ [saveWorkExperience] Exception occurred: $e");
      return false;
    }
  }

}

