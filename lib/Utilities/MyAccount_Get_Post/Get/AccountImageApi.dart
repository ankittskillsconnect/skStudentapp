import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/AccountScrren_Image_Name_Model.dart';

class AccountImageApi {
  static Future<AcountScreenImageModel?> fetchAccountScreenData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final connectSid = prefs.getString('connectSid') ?? '';

      final response = await http.get(
        Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/personal-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Cookie': 'connect.sid=$connectSid'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("✅ Full JSON AcountScreen: $jsonData");

        if (jsonData.containsKey('personalDetails')) {
          final details = jsonData['personalDetails'];
          print("📦 AcountScreen: $details");

          if (details is List && details.isNotEmpty && details[0] is Map) {
            print("🔍 First Entry: ${details[0]}");
            return AcountScreenImageModel.fromJson(details[0]);
          }
        }
      }
      else {
        print('❌ Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in fetchAccountScreenData: $e');
    }
    return null;
  }
}
