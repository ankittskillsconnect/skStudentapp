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

    // Check cached data
    final cachedList = prefs.getStringList(_cacheKey);
    if (cachedList != null && cachedList.isNotEmpty) {
      print("🟡 Using cached languages: ${cachedList.length}");
      print("📜 Raw cached data: $cachedList");

      try {
        allLanguages = cachedList.map((item) {
          final decoded = jsonDecode(item);
          print("📝 Decoded JSON: $decoded");
          final lang = LanguageMasterModel.fromJson(decoded);
          print("📝 Cached => ID: ${lang.languageId}, Name: ${lang.languageName}");
          return lang;
        }).toList();

        // Validate cached data
        bool isValidCache = allLanguages.every((lang) => lang.languageId != 0);
        if (!isValidCache) {
          print("❌ Invalid cache: Found languages with ID 0. Clearing cache.");
          await prefs.remove(_cacheKey);
          allLanguages = [];
        } else {
          return allLanguages;
        }
      } catch (e) {
        print("❌ Error decoding cached languages: $e");
        print("🧹 Clearing corrupted cache");
        await prefs.remove(_cacheKey);
      }
    }

    // Fetch from language-details API
    final effectiveConnectSid = connectSid.isEmpty
        ? 's%3A90I8VK0ssLCW9DjFq4xSLrkDEI7xUgCG.JFNw9cZG8Txw07rqZ6gs7K8bGpm4pMApT7Yu9FqqjbY'
        : connectSid;

    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$effectiveConnectSid',
    };

    final url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/language-details');

    try {
      final request = http.Request('GET', url)..headers.addAll(headers);
      final response = await request.send().timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.StreamedResponse(Stream.value([]), 408),
      );

      final resBody = await response.stream.bytesToString();
      print("📥 API response code: ${response.statusCode}");
      print("📥 API response body: $resBody");

      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        if (data is Map && data['status'] == true) {
          final languageData = data['langugeList'];
          if (languageData is List) {
            allLanguages = languageData.map((item) {
              final lang = LanguageMasterModel.fromJson(item);
              print("📝 API => ID: ${lang.languageId}, Name: ${lang.languageName}");
              return lang;
            }).toList();

            // Validate API data
            if (allLanguages.any((lang) => lang.languageId == 0)) {
              print("❌ API returned languages with ID 0. Discarding data.");
              return [];
            }

            // Cache the fetched languages
            final encodedList = allLanguages.map((lang) => jsonEncode(lang.toJson())).toList();
            await prefs.setStringList(_cacheKey, encodedList);
            print("✅ Fetched & cached ${allLanguages.length} languages from API.");
          } else {
            print("⚠️ Unexpected data format in 'langugeList' field.");
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

  static Future<void> clearCachedLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    print("🧹 Cleared cached languages");
  }
}
