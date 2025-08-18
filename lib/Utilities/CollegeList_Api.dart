import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ApiConstants.dart';

class ApiService {
  static const String _baseUrl =
      '${ApiConstants.baseUrl}common/get-college-list';

  static Future<List<String>> fetchCollegeList({int page = 1}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(_baseUrl));
    request.body = json.encode({
      "college_id": "",
      "state_id": "",
      "city_id": "",
      "course_id": "",
      "specialization_id": "",
      "search": "",
      "page": page,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = json.decode(await response.stream.bytesToString());
        List<String> colleges = (data['data']['options'] as List)
            .map((item) => item['text'] as String)
            .toList();
        return colleges;
      } else {
        print('Failed to load colleges: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error fetching college list: $e');
      return [];
    }
  }
}
