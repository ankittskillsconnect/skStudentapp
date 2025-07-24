import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sk_loginscreen1/Model/CertificateDetails_Model.dart';

class CertificateApi {
  static Future<List<CertificateModel>> fetchCertificateApi({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      var url = Uri.parse(
          'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/certification-details'      );
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };

      var request = http.Request('GET', url);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String jsonString = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(jsonString);

        final List<dynamic> certificates = data['certification'] ?? [];
        return certificates
            .map((e) => CertificateModel.fromJson(e))
            .toList();
      }else {
        throw Exception('Failed to load education details');
      }
    } catch (e) {
      print('❌ Error in EducationDetailApi: $e');
      return [];
    }
  }
}
