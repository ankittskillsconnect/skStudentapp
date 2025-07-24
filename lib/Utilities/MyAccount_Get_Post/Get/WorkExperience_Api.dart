import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sk_loginscreen1/Model/WorkExperience_Model.dart';

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
}
