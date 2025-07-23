import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobApi {
  static Future<List<Map<String, dynamic>>> fetchJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final bearerToken =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTA1NDc2LCJlbWFpbCI6ImJoYXZlc2guc2tpbGxzY29ubmVjdCtzdHVkZW50ZHVtbXlAZ21haWwuY29tIiwidXNlcl90eXBlIjo0LCJzb3VyY2UiOiJteXNxbCIsImNvbGxlZ2VfaWQiOjE4MDU4LCJjb2xsZWdlX25hbWUiOiJTa2lsbHNjb25uZWN0IENvbGxlZ2UiLCJtb3UiOiJodHRwczovL3NraWxsc2Nvbm5lY3QuczMuYXAtc291dGgtMS5hbWF6b25hd3MuY29tL2luc3RpdHV0ZU9uYm9hcmRpbmcvYWJoaXNoZWtfMjYwX01PVS5wZGYiLCJtb3Vfc2lnbmVkIjoiaHR0cHM6Ly9za2lsbHNjb25uZWN0LnMzLmFwLXNvdXRoLTEuYW1hem9uYXdzLmNvbS9pbnN0aXR1dGVPbmJvYXJkaW5nL2FiaGlzaGVrXzI2MF9NT1UucGRmIiwiaWF0IjoxNzUyMTI5MDc5LCJleHAiOjE3NTIzMDE4Nzl9.DQUqunhHpM5YCLUYCNhYAT5J-OjSaeQYVYmylCbDM74';

    final response = await http
        .post(
      Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/jobs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      },
      body: '',
    )
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true && data['jobs'] is List) {
        final jobsList = data['jobs'] as List;
        // print(" Total jobs fetched: ${jobsList.length}");
        return jobsList.map<Map<String, dynamic>>((job) {
          final title = job['title'] ?? '';
          final company = job['company_name'] ?? '';
          final threeCities = job['three_cities_name'] ?? '';
          final totalCities = job['total_cities'] ?? 0;
          String location;
          if ((threeCities as String).isNotEmpty) {
            location = totalCities > 3
                ? '$threeCities + ${totalCities - 3} more'
                : threeCities;
          } else {
            location = 'Location not specified';
          }
          final skills = (job['skills'] as String?)?.split(',') ?? [];
          final tags = [
            job['job_type'] as String? ?? '',
            ...skills,
          ].where((tag) => tag.isNotEmpty).toList();
          final createdOn = DateTime.tryParse(job['created_on'] ?? '') ?? DateTime.now();
          final now = DateTime.now();
          final diff = now.difference(createdOn);
          final postTime = diff.inMinutes < 60
              ? '${diff.inMinutes} mins ago'
              : diff.inHours < 24
              ? '${diff.inHours} hr ago'
              : '${diff.inDays} days ago';
          final salary = '₹${job['cost_to_company'] ?? '0'} LPA';
          final expiry = _calculateExpiry(job['end_date']);
          return {
            'title': title,
            'company': company,
            'location': location,
            'salary': salary,
            'postTime': postTime,
            'expiry': expiry,
            'tags': tags,
            'logoUrl': job['company_logo'],
            'jobToken': job['job_invitation_token'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Invalid response format: ${data['msg'] ?? 'No message'}');
      }
    } else {
      throw Exception('Failed to fetch jobs: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  static String _calculateExpiry(String? endDate) {
    if (endDate == null) return 'N/A';
    final expiry = DateTime.tryParse(endDate);
    if (expiry == null) return 'N/A';

    final now = DateTime.now();
    final daysLeft = expiry.difference(now).inDays;
    return daysLeft > 0 ? '$daysLeft days left' : 'Expired';
  }
}
