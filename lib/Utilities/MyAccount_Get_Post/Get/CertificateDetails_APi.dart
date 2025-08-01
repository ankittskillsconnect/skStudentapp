import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sk_loginscreen1/Model/CertificateDetails_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class CertificateApi {
  static Future<List<CertificateModel>> fetchCertificateApi({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      var url = Uri.parse(
          'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/certification-details');
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };
      final payload = Jwt.parseJwt(authToken);
      final userId = payload['id'] as int;
      print('🔑 Extracted userId from authToken: $userId');

      url = url.replace(queryParameters: {'user_id': userId.toString()});

      var request = http.Request('GET', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final String jsonString = await response.stream.bytesToString();

        final Map<String, dynamic> data = jsonDecode(jsonString);
        final List<dynamic> certificates = data['certification'] ?? [];
        return certificates.map((e) => CertificateModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load certificate details: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Error in fetchCertificateApi: $e');
      return [];
    }
  }

  static Future<CertificateModel> saveCertificateApi({
    required CertificateModel model,
    required String authToken,
    required String connectSid,
  }) async {
    try {
      final isNew = model.certificationId == null;
      final body = model.toJson(isNew: isNew);
      print('📤 Final body sent: $body');
      print('🔍 Entering saveCertificateApi');
      print('📋 Input Parameters: model=$model, authToken=$authToken, connectSid=$connectSid');

      var url = Uri.parse(
          'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-certification');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken${connectSid.isNotEmpty ? '; connect.sid=$connectSid' : ''}',
      };
      print('🧾 Request Headers: $headers');

      // Extract user_id from authToken
      final payload = Jwt.parseJwt(authToken);
      final userId = payload['id'] as int;
      print('🔑 Extracted userId from authToken: $userId');

      // Optionally add user_id to the body if required by the server
      final updatedBody = {...body, 'user_id': userId};

      var request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = jsonEncode(updatedBody);
      print('📦 Raw Request Body (before encoding): ${updatedBody}');
      print('📦 Encoded Request Body: ${request.body}');

      print('🚀 Sending HTTP POST request at ${DateTime.now().toIso8601String()}');
      http.StreamedResponse response = await request.send();
      print('📡 Response Status Code: ${response.statusCode}');
      print('📡 Response Reason Phrase: ${response.reasonPhrase}');
      print('📡 Full Response Headers: ${response.headers.entries.map((e) => '${e.key}: ${e.value}').join('\n')}');

      final String jsonString = await response.stream.bytesToString();
      print('📩 Raw Response Body: $jsonString');

      final Map<String, dynamic> data = jsonDecode(jsonString);
      print('📊 Parsed Response Data: $data');

      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        final prefs = await SharedPreferences.getInstance();
        if (setCookie.contains('authToken=')) {
          final newAuthToken = setCookie.split('authToken=')[1].split(';')[0];
          await prefs.setString('authToken', newAuthToken);
          print('🔄 Updated authToken stored: $newAuthToken');
        }
      }

      if (response.statusCode == 200) {
        print('✅ Success: Parsing certificate from response');
        return CertificateModel.fromJson(data['certificate'] ?? data);
      } else {
        print('❌ Error: Non-200 status code received. Detailed error: ${data['msg'] ?? response.reasonPhrase}');
        throw Exception('Failed to save certificate: ${data['msg'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Exception Caught in saveCertificateApi: $e');
      if (e is http.ClientException) {
        print('🌐 Network Error: ${e.message}');
      } else if (e is FormatException) {
        print('🔧 JSON Parsing Error: ${e.message}');
      } else if (e is Exception) {
        print('🛑 General Exception: ${e.toString()}');
      }
      throw Exception('Error saving certificate: $e');
    } finally {
      print('🔚 Exiting saveCertificateApi');
    }
  }
}