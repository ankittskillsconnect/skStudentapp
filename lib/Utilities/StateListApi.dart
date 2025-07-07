import 'dart:convert';
import 'package:http/http.dart' as http;

class StateListApi {
  static const String _url =
      'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/state/list';

  static Future<List<String>> fetchStates({
    required int countryId,
    required String authToken,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken',
    };

    final requestBody = {
      "country_id": countryId,
      "offset": 10,
    };

    final request = http.Request(
      'POST',
      Uri.parse(_url),
    );

    request.body = jsonEncode(requestBody);
    request.headers.addAll(headers);

    print("📡 Sending state fetch request...");
    print("📍 URL: $_url");
    print("📦 Request Body: ${jsonEncode(requestBody)}");
    print("🔐 Token Start: ${authToken.substring(0, 20)}...");

    try {
      final response = await request.send();

      print("✅ Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonString = await response.stream.bytesToString();
        print("📥 Raw Response: $jsonString");

        final decoded = jsonDecode(jsonString);

        if (decoded is Map && decoded.containsKey('data')) {
          final List<dynamic> dataList = decoded['data'];
          final List<String> states =
          dataList.map((e) => e['name'].toString()).toList();

          print("🏞️ States fetched: $states");
          return states;
        } else {
          print("⚠️ Unexpected response format.");
          return [];
        }
      } else {
        print("❌ Failed to fetch states: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("🚨 Error fetching states: $e");
      return [];
    }
  }
}
