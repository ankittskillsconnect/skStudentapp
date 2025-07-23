import 'dart:convert';
import 'package:http/http.dart' as http;

class SpecializationListApi {
  static Future<List<String>> fetchSpecializations({
    required String specializationName,
    required String courseId,
    required String authToken,
    required String connectSid,
  }) async {
    try {
      var url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/courses-specilization/list');
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };

      var body = jsonEncode({
        "specilization_name": specializationName,
        "course_id": courseId,
        "status": ""
      });
      var request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final response = await request.send().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("❌ Request timed out for specialization '$specializationName' with course ID '$courseId'");
          return http.StreamedResponse(Stream.value([]), 408);
        },
      );

      final resBody = await response.stream.bytesToString();
      print("🔍 API Response for specialization '$specializationName' with course ID '$courseId': $resBody");

      if (response.statusCode == 200) {
        final data = json.decode(resBody);

        if (data is Map && data['status'] == true) {
          if (data['data'] is List) {
            List options = data['data'];
            return options
                .map<String>((item) => item['specilization_name']?.toString() ?? '')
                .where((name) => name.isNotEmpty)
                .toList();
          } else if (data['data'] == false) {
            print("⚠️ No specializations found for '$specializationName' with course ID '$courseId'. Check case or token validity.");
            return [];
          } else {
            print("⚠️ Unexpected 'data' format, expected List or false. Response: $resBody");
            return [];
          }
        } else {
          print("⚠️ Invalid response structure, expected status: true. Response: $resBody");
          return [];
        }
      } else {
        print("❌ API failed for specialization '$specializationName' with course ID '$courseId': ${response.statusCode} - ${response.reasonPhrase}");
        print("Response body: $resBody");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching specializations for '$specializationName' with course ID '$courseId': $e");
      return [];
    }
  }
}