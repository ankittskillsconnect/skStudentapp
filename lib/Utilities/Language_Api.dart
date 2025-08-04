import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/LanguageMaster_Model.dart';

class LanguageListApi {
  static const String _cacheKey = 'cached_languages';

  static Future<List<LanguageMasterModel>> fetchLanguages({
    required String authToken,
    required String connectSid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<LanguageMasterModel> allLanguages = [];

    final cachedList = prefs.getStringList(_cacheKey);
    if (cachedList != null && cachedList.isNotEmpty) {
      print("🟡 Using cached languages: ${cachedList.length}");

      try {
        allLanguages = cachedList.map((item) {
          final decoded = jsonDecode(item);
          final lang = LanguageMasterModel.fromJson(decoded);
          print("📝 Cached => ID: ${lang.languageId}, Name: ${lang.languageName}");
          return lang;
        }).toList();
        return allLanguages;
      } catch (e) {
        print("❌ Error decoding cached languages: $e");
        print("🧹 Clearing corrupted cache");
        await prefs.remove(_cacheKey);
        // After clearing cache, fall through to fetch from API
      }
    }

    // Prepare headers for API call
    final effectiveConnectSid = connectSid.isEmpty
        ? 's%3A90I8VK0ssLCW9DjFq4xSLrkDEI7xUgCG.JFNw9cZG8Txw07rqZ6gs7K8bGpm4pMApT7Yu9FqqjbY'
        : connectSid;

    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$effectiveConnectSid',
    };

    final url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/language/list');

    try {
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = jsonEncode({});

      final response = await request.send().timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.StreamedResponse(Stream.value([]), 408),
      );

      final resBody = await response.stream.bytesToString();
      print("📥 API response code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        if (data is Map && data['status'] == true) {
          final languageData = data['data'];
          if (languageData is List) {
            allLanguages = languageData.map((item) {
              return LanguageMasterModel.fromJson(item);
            }).toList();

            // Cache the valid response for next time
            final encodedList = allLanguages.map((lang) => jsonEncode(lang.toJson())).toList();
            await prefs.setStringList(_cacheKey, encodedList);

            print("✅ Fetched & cached ${allLanguages.length} languages from API.");
          } else {
            print("⚠️ Unexpected data format in 'data' field.");
          }
        } else {
          print("⚠️ API returned status false or invalid data structure.");
        }
      } else {
        print("❌ Failed to fetch languages: ${response.statusCode} - $resBody");
      }
    } catch (e) {
      print("🚨 Exception during fetchLanguages: $e");
    }

    return allLanguages;
  }

  // Utility method to clear cached languages manually
  static Future<void> clearCachedLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    print("🧹 Cleared cached languages");
  }
}
