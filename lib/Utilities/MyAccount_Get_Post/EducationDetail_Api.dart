import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/EducationDetail_Model.dart';
import '../ApiConstants.dart';

class EducationDetailApi {
  static Future<List<EducationDetailModel>> fetchEducationDetails({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      var url = Uri.parse(
        '${ApiConstants.baseUrl}profile/student/education-details',
      );

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

        final List<dynamic> educationList = data['educationDetails'] ?? [];

        return educationList
            .map((e) => EducationDetailModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load education details');
      }
    } catch (e) {
      print('❌ Error in EducationDetailApi: $e');
      return [];
    }
  }
}