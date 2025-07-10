import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobApi {
  static Future<List<Map<String, dynamic>>> fetchJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final bearerToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTA1NDc2LCJlbWFpbCI6ImJoYXZlc2guc2tpbGxzY29ubmVjdCtzdHVkZW50ZHVtbXlAZ21haWwuY29tIiwidXNlcl90eXBlIjo0LCJzb3VyY2UiOiJteXNxbCIsImNvbGxlZ2VfaWQiOjE4MDU4LCJjb2xsZWdlX25hbWUiOiJTa2lsbHNjb25uZWN0IENvbGxlZ2UiLCJtb3UiOiJodHRwczovL3NraWxsc2Nvbm5lY3QuczMuYXAtc291dGgtMS5hbWF6b25hd3MuY29tL2luc3RpdHV0ZU9uYm9hcmRpbmcvYWJoaXNoZWtfMjYwX01PVS5wZGYiLCJtb3Vfc2lnbmVkIjoiaHR0cHM6Ly9za2lsbHNjb25uZWN0LnMzLmFwLXNvdXRoLTEuYW1hem9uYXdzLmNvbS9pbnN0aXR1dGVPbmJvYXJkaW5nL2FiaGlzaGVrXzI2MF9NT1UucGRmIiwiaWF0IjoxNzUyMTI5MDc5LCJleHAiOjE3NTIzMDE4Nzl9.DQUqunhHpM5YCLUYCNhYAT5J-OjSaeQYVYmylCbDM74'; // Replace with dynamic token if needed

    final response = await http.post(
      Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/jobs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      },
      body: '',
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true && data['jobs'] is List) {
        return data['jobs'].map<Map<String, dynamic>>((job) {
          final skills = (job['skills'] as String?)?.split(',') ?? [];
          final tags = [job['job_type'] as String, ...skills].where((tag) => tag.isNotEmpty).toList();
          final createdOn = DateTime.parse(job['created_on'] as String);
          final now = DateTime.now();
          final hoursAgo = now.difference(createdOn).inHours;
          final postTime = hoursAgo < 24 ? '$hoursAgo hr ago' : '${hoursAgo ~/ 24} days ago' ;
          // print("Job object: $job");// can del debug

          return {
            'title': job['title'] as String,
            'company': job['company_name'] as String,
            'location': job['three_cities_name'] as String,
            'salary': '₹${job['cost_to_company']} LPA',
            'postTime': postTime,
            'expiry': '7 days left',
            'tags': tags,
            'logoUrl': job['company_logo'] as String?,
          };

        }).toList();
      } else {
        throw Exception('Invalid response format: ${data['msg']}');
      }
    } else {
      throw Exception('Failed to fetch jobs: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}