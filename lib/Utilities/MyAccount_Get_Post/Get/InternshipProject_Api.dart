import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';

class InternshipProjectApi {
  static Future<List<InternshipProjectModel>> fetchInternshipProjects({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      var url = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/project-internship-details',
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

        final List<dynamic> rawList = data['projectInternship'] ?? [];
        return rawList
            .map((e) => InternshipProjectModel.fromJson(e))
            .toList();
      } else {
        throw Exception(' Failed to load internship/project details');
      }
    } catch (e) {
      print(' Error in InternshipProjectApi: $e');
      return [];
    }
  }
}
