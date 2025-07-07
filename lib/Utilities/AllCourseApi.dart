import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CourseListApi {
  static const String _baseUrl =
      'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/course/list';

  static Future<List<String>> fetchCourses({required String courseName}) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=your_token_here'
      };

      var request = http.Request(
        'POST',
        Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/course/list'),
      );
      request.body = json.encode({"course_name": courseName});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        print("📦 Full course API response: $data");

        if (data["status"] == true && data["data"] is List) {
          return List<String>.from(data["data"].map((e) => e["course_name"].toString()));
        } else {
          print("❌ Invalid format in response data: ${data["data"]}");
          return []; // Return empty list if data is not List
        }
      } else {
        print("❌ Course API failed: ${response.reasonPhrase}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching course list: $e");
      return [];
    }
  }


}
