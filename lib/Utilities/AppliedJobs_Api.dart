import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/Applied_Jobs_Model.dart';

class AppliedJobsApi {
  static Future<List<AppliedJobModel>> fetchAppliedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    print("🔐 authToken: $authToken");
    print("🍪 connectSid: $connectSid");

    const String url = 'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/jobs';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Cookie': 'connect.sid=$connectSid',
        },
        body: jsonEncode({
          "apply_type": "Applied",
          "page": 1,
          "limit": 20,
        }),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("📦 Decoded Data: $data");

        if (data['jobs'] == null) {
          print("❌ 'jobs' field is null!");
          return [];
        }

        if (data['jobs'] is! List) {
          print("❌ 'jobs' field is not a list: ${data['jobs'].runtimeType}");
          return [];
        }

        final jobs = data['jobs'] as List<dynamic>;

        final parsedJobs = jobs.map((jobJson) {
          try {
            final model = AppliedJobModel.fromJson(jobJson);
            print("✅ Parsed job: ${model.title}");
            return model;
          } catch (e) {
            print("❌ Error parsing job: $e");
            return null;
          }
        }).whereType<AppliedJobModel>().toList();

        return parsedJobs;


    } else {
        print("❌ Failed with status: ${response.statusCode}");
        throw Exception('Failed to fetch applied jobs');
      }
    } catch (e) {
      print("❗ Exception occurred: $e");
      rethrow;
    }
  }
}
