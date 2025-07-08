import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LanguageListApi {
  static Future<List<String>> fetchLanguages({
    required String authToken,
    required String connectSid,
  }) async {
    List<String> allLanguages = [];
    final prefs = await SharedPreferences.getInstance();
    final cachedLanguages = prefs.getStringList('cached_languages');

    if (cachedLanguages != null && cachedLanguages.isNotEmpty) {
      print("✅ Using cached languages: ${cachedLanguages.length} - $cachedLanguages");
      return List<String>.from(cachedLanguages.where((lang) => lang.isNotEmpty));
    }

    // Fallback for connectSid if empty
    final effectiveConnectSid = connectSid.isEmpty
        ? 's%3A90I8VK0ssLCW9DjFq4xSLrkDEI7xUgCG.JFNw9cZG8Txw07rqZ6gs7K8bGpm4pMApT7Yu9FqqjbY'
        : connectSid;
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$effectiveConnectSid',
    };

    final url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/language/list');

    try {
      print("📡 Fetching languages with headers: Cookie=${headers['Cookie']}, authToken=${authToken.substring(0, 20)}...");

      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = jsonEncode({});

      final response = await request.send().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("❌ Request timed out for languages");
          return http.StreamedResponse(Stream.value([]), 408);
        },
      );

      print("📨 Status Code: ${response.statusCode}");
      final resBody = await response.stream.bytesToString();
      print("✅ Full response body: $resBody");

      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        if (data is Map && data['status'] == true) {
          final languageData = data['data'];
          if (languageData is List) {
            allLanguages = languageData.map((item) => item['language_name']?.toString() ?? '').where((name) => name.isNotEmpty).toList();
            print("🎯 Parsed languages from list: $allLanguages");
          } else if (languageData is Map && languageData['options'] is List) {
            allLanguages = (languageData['options'] as List<dynamic>).map((e) => e['language_name'].toString()).where((name) => name.isNotEmpty).toList();
            print("🎯 Parsed languages from options: $allLanguages");
          } else {
            print("⚠️ Unexpected 'data' format. Response data: $languageData");
          }
        } else {
          print("⚠️ Invalid response structure, expected status: true. Response: $resBody");
        }
      } else {
        print("❌ Error: ${response.statusCode} - ${response.reasonPhrase}");
      }

      if (allLanguages.isNotEmpty) {
        await prefs.setStringList('cached_languages', allLanguages);
      } else {
        print("⚠️ No valid languages fetched, cache not updated");
      }
      return allLanguages;
    } catch (e) {
      print("🔥 Exception in fetchLanguages: $e");
      return [];
    }
  }
}