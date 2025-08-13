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

  static Future<bool> saveInternshipProject({
    required InternshipProjectModel model,
    required String authToken,
    required String connectSid,
  }) async {
    try {
      // print("📦 [saveInternshipProject] Starting API call...");
      // print("📎 internshipId: ${model.internshipId}");
      // print("📎 userId: ${model.userId}");
      // print("📎 type: ${model.type}");
      // print("📎 projectName: ${model.projectName}");
      // print("📎 companyName: ${model.companyName}");
      // print("📎 duration: ${model.duration} ${model.durationPeriod}");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'Cookie': 'connect.sid=$connectSid',
      };

      final body = jsonEncode(model.toJson());
       // print("📤 Request Body: $body");

      final url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-project-internship');
      // print("🌐 POST URL: $url");

      final response = await http.post(url, headers: headers, body: body);
      // print("📥 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("✅ API Success: ${decoded['msg'] ?? 'No message'}");
        return true;
      } else {
        try {
          final error = jsonDecode(response.body);
          print("❗ Server Error: ${error['msg'] ?? 'Unknown error'}");
        } catch (_) {
          print("❗ Error parsing response body: ${response.body}");
        }
        return false;
      }
    } catch (e, stack) {
      print("❌ Exception during API call: $e");
      print("🧱 StackTrace: $stack");
      return false;
    }
  }

  static Future<bool> deleteProjectInternship({
    required int internshipId,
    required String authToken,
    required String connectSid,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
      'authToken=$authToken${connectSid.isNotEmpty ? '; connect.sid=$connectSid' : ''}',
    };
    var url = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/delete/$internshipId?action=project');
    try {
      final request = http.Request('DELETE', url)..headers.addAll(headers);

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('✅ Deleted Internship ID $internshipId successfully.');
        return true;
      } else {
        print(
            '❌ Failed to delete Internship ID $internshipId: ${response.statusCode} - $responseBody');
        return false;
      }
    } catch (e) {
      print('🚨 Exception during deleteInternship: $e');
      return false;
    }
  }

}

