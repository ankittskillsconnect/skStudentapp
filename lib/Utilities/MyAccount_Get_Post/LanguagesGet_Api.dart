import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/Languages_Model.dart';
import '../ApiConstants.dart';

class LanguageDetailApi {
  static Future<List<LanguagesModel>> fetchLanguages({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}profile/student/language-details',
      );
      final headers = {
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };
      print('🔍 [fetchLanguages] Sending GET request to: $url');
      print('🔍 [fetchLanguages] Headers: $headers');

      final request = http.Request('GET', url)..headers.addAll(headers);
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        print('🔍 [fetchLanguages] Response body: $responseBody');
        final jsonData = json.decode(responseBody);

        if (jsonData is Map && jsonData.containsKey('languages') && jsonData['languages'] is List) {
          final langList = jsonData['languages'] as List;
          print('🔍 [fetchLanguages] Languages list found with ${langList.length} items');
          print('🔍 [fetchLanguages] First language item: ${langList.isNotEmpty ? langList[0] : 'Empty'}');
          return langList.map((jsonItem) => LanguagesModel.fromJson(jsonItem)).toList();
        }
        throw Exception('Invalid response format');
      }
      throw Exception('Failed to fetch languages: ${streamedResponse.reasonPhrase}');
    } catch (e, stackTrace) {
      print('🚨 [fetchLanguages] Language fetch error: $e');
      print('🚨 [fetchLanguages] Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateLanguages({
    required String authToken,
    required String connectSid,
    required LanguagesModel language,
  }) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}profile/student/update-languages',
    );
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
    };

    if (language.languageId == 0) {
      print('❌ [updateLanguages] Invalid language_id: 0 for ${language.languageName}');
      return {'success': false, 'data': 'Invalid language_id'};
    }

    final body = json.encode(language.toJson());
    print('🔍 [updateLanguages] Sending POST request to: $url');
    print('🔍 [updateLanguages] Headers: $headers');
    print('📤 [updateLanguages] Payload: $body');

    try {
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('🔍 [updateLanguages] Response status: ${response.statusCode}');
      print('🔍 [updateLanguages] Response body: $responseBody');

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        print('✅ [updateLanguages] Language updated successfully. Parsed response: $jsonData');

        int? newId;
        if (jsonData is Map && jsonData.containsKey('data') && jsonData['data'] is Map) {
          newId = jsonData['data']['id'] as int?;
          print('✅ [updateLanguages] Found ID in response: $newId');
        } else {
          print('⚠️ [updateLanguages] No ID in response, fetching languages...');
          final languages = await fetchLanguages(authToken: authToken, connectSid: connectSid);
          final newLanguage = languages.lastWhere(
                (lang) => lang.languageId == language.languageId && lang.proficiency == language.proficiency,
            orElse: () {
              print('⚠️ [updateLanguages] No matching language found for languageId: ${language.languageId}, proficiency: ${language.proficiency}');
              return language;
            },
          );
          newId = newLanguage.id;
          print('✅ [updateLanguages] Fetched ID: $newId for ${language.languageName}');
        }

        return {
          'success': true,
          'data': {
            'id': newId,
            'language': LanguagesModel(
              id: newId,
              languageId: language.languageId,
              languageName: language.languageName,
              proficiency: language.proficiency,
            ),
          },
        };
      }
      print('❌ [updateLanguages] Failed: ${response.statusCode} - $responseBody');
      return {'success': false, 'data': responseBody};
    } catch (e, stackTrace) {
      print('🚨 [updateLanguages] Exception: $e');
      print('🚨 [updateLanguages] Stack trace: $stackTrace');
      return {'success': false, 'data': e.toString()};
    }
  }

  static Future<bool> deleteLanguage({
    required int? id,
    required String authToken,
    required String connectSid,
  }) async {
    if (id == null || id == 0) {
      print('❌ [deleteLanguage] Invalid ID: $id. Ensure language is synced with backend.');
      return false;
    }

    print('🔍 [deleteLanguage] Starting deletion for ID: $id');
    final url = Uri.parse('${ApiConstants.baseUrl}profile/student/delete/$id?action=language');
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
    };

    try {
      final request = http.Request('DELETE', url)..headers.addAll(headers);
      print('🔍 [deleteLanguage] Sending DELETE request to: $url');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('🔍 [deleteLanguage] Response status: ${response.statusCode}');
      print('🔍 [deleteLanguage] Response body: $responseBody');

      if (response.statusCode == 200) {
        print('✅ [deleteLanguage] Deleted language ID $id successfully.');
        return true;
      }
      print('❌ [deleteLanguage] Failed to delete language ID $id: ${response.statusCode} - $responseBody');
      return false;
    } catch (e, stackTrace) {
      print('🚨 [deleteLanguage] Exception during deleteLanguage: $e');
      print('🚨 [deleteLanguage] Stack trace: $stackTrace');
      return false;
    }
  }
}