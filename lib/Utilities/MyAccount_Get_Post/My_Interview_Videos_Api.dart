import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/My_Interview_Videos_Model.dart';
import '../ApiConstants.dart';

class VideoIntroApi {
  Future<VideoIntroModel?> fetchVideoIntroQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    if (authToken.isEmpty) {
      debugPrint('❌ Missing authToken.');
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}profile/student/video-intro-details'),
        headers: {
          'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['videoIntro'];

        if (data != null && data is List && data.isNotEmpty) {
          return VideoIntroModel.fromJson(data.first);
        } else {
          debugPrint("⚠️ No 'videoIntro' data found.");
        }
      } else {
        debugPrint(
            "❌ Failed to fetch: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      debugPrint('❌ Exception during fetch: $e');
    }
    return null;
  }
}
