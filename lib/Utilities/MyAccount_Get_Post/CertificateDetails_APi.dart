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

      var url = Uri.parse(
          'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-certification');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken${connectSid.isNotEmpty ? '; connect.sid=$connectSid' : ''}',
      };

      final payload = Jwt.parseJwt(authToken);
      final userId = payload['id'] as int;

      final updatedBody = {...body, 'user_id': userId};

      var request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = jsonEncode(updatedBody);

      http.StreamedResponse response = await request.send();

      final String jsonString = await response.stream.bytesToString();

      final Map<String, dynamic> data = jsonDecode(jsonString);

      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        final prefs = await SharedPreferences.getInstance();
        if (setCookie.contains('authToken=')) {
          final newAuthToken = setCookie.split('authToken=')[1].split(';')[0];
          await prefs.setString('authToken', newAuthToken);
        }
      }

      if (response.statusCode == 200) {
        return CertificateModel.fromJson(data['certificate'] ?? data);
      } else {
        throw Exception('Failed to save certificate: ${data['msg'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error saving certificate: $e');
    }
  }
}