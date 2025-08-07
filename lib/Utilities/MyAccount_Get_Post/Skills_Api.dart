import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/Skiils_Model.dart';

class SkillsApi {
  static Future<List<SkillsModel>> fetchSkills({
    required String authToken,
    required String connectSid,
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/skills-details',
      );

      final headers = {
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      };

      final request = http.Request('GET', uri)..headers.addAll(headers);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);

        if (decoded['status'] == true && decoded['skills'] != null) {
          final skillsList = <SkillsModel>[];

          for (var skillItem in decoded['skills']) {
            final rawSkills = skillItem['skills'] as String?;
            if (rawSkills != null && rawSkills.isNotEmpty) {
              final individualSkills = rawSkills.split(',');
              for (var s in individualSkills) {
                skillsList.add(SkillsModel(skills: s.trim()));
              }
            }
          }

          return skillsList;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch skills: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Skills API error: $e');
      return [];
    }
  }
}

