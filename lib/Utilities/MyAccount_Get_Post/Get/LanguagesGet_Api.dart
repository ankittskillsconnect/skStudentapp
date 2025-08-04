import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/Languages_Model.dart';

class LanguageDetailApi {
  static Future<List<LanguagesModel>> fetchLanguages({
    required String authToken,
    required String connectSid,
  }) async {
    try {

      final url = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/language-details',
      );

      final headers = {
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };

      final request = http.Request('GET', url)..headers.addAll(headers);
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        if (jsonData is Map) {
          if (jsonData.containsKey('languages') && jsonData['languages'] is List) {
            final langList = jsonData['languages'] as List;
            print(" Languages list found with ${langList.length} items");
            print(" First language item: ${langList.isNotEmpty ? langList[0] : 'Empty'}");

            return langList
                .map((jsonItem) => LanguagesModel.fromJson(jsonItem))
                .toList();
          } else if (jsonData.containsKey('data') && jsonData['data'] is List) {
            final langList = jsonData['data'] as List;
            print(" 'data' list found with ${langList.length} items");
            print(" First item: ${langList.isNotEmpty ? langList[0] : 'Empty'}");

            return langList
                .map((jsonItem) => LanguagesModel.fromJson(jsonItem))
                .toList();
          } else {
            throw Exception(" Neither 'languages' nor 'data' key present or not a list");
          }
        } else {
          throw Exception(" JSON is not a Map");
        }
      } else {
        throw Exception(
          'Failed to fetch languages: ${streamedResponse.reasonPhrase}',
        );
      }
    } catch (e) {
      print(' Language fetch error: $e');
      return [];
    }
  }


  static Future<bool> updateLanguages({
    required String authToken,
    required String connectSid,
    required LanguagesModel language,
  }) async {
    final url = Uri.parse(
      'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-languages',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
    };

    final body = json.encode(language.toJson());

    try {
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ updateLanguages response: $responseBody");
        return true;
      } else {
        print("❌ updateLanguages failed: ${response.statusCode} - $responseBody");
        return false;
      }
    } catch (e) {
      print("🚨 Exception in updateLanguages: $e");
      return false;
    }
  }
}