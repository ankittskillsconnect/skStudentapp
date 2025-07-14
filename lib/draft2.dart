// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class JobDetailApi {
//   static Future<Map<String, dynamic>> fetchJobDetail({
//     required String token,
//   }) async {
//     if (token.isEmpty) {
//       throw Exception('Job token is missing.');
//     }
//
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken') ?? '';
//     final connectSid = prefs.getString('connectSid') ?? '';
//
//     final headers = {
//       'Content-Type': 'application/json',
//       'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
//     };
//     final body = jsonEncode({"job_id": "", "slug": "", "token": token});
//
//     final response = await http
//         .post(
//       Uri.parse(
//         'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/jobs/details',
//       ),
//       headers: headers,
//       body: body,
//     )
//         .timeout(const Duration(seconds: 10));
//
//     if (response.statusCode == 200) {
//       try {
//         final data = json.decode(response.body);
//         print('📥 Full API Response: $data');
//
//         if (data['status'] == true &&
//             data['job_details'] != null &&
//             data['job_details'] is Map) {
//           final jobDetails = data['job_details'] as Map<String, dynamic>;
//           print('✅ Parsed job_details keys: ${jobDetails.keys}');
//
//           String jobDescription = jobDetails['job_description'] ?? '';
//           List<String> responsibilities = [];
//           List<String> requirements = [];
//           List<String> niceToHave = [];
//
//           // Responsibilities
//           if (jobDescription.contains('<strong>Responsibilities:</strong>')) {
//             final respStart =
//                 jobDescription.indexOf('<strong>Responsibilities:</strong>') +
//                     '<strong>Responsibilities:</strong>'.length;
//             final respEnd = jobDescription.contains('<strong>Requirements:</strong>')
//                 ? jobDescription.indexOf('<strong>Requirements:</strong>', respStart)
//                 : jobDescription.length;
//             final respText = jobDescription
//                 .substring(respStart, respEnd)
//                 .split('<li>')
//                 .where((part) => part.contains('</li>'))
//                 .map((part) =>
//                 part.split('</li>')[0].replaceAll(RegExp(r'<[^>]+>'), '').trim())
//                 .where((item) => item.isNotEmpty)
//                 .toList();
//             responsibilities.addAll(respText);
//           }
//
//           // Requirements
//           if (jobDescription.contains('<strong>Requirements:</strong>')) {
//             final reqStart =
//                 jobDescription.indexOf('<strong>Requirements:</strong>') +
//                     '<strong>Requirements:</strong>'.length;
//             final reqEnd = jobDescription.contains('<strong>Nice to Have:</strong>')
//                 ? jobDescription.indexOf('<strong>Nice to Have:</strong>', reqStart)
//                 : jobDescription.length;
//             final reqText = jobDescription
//                 .substring(reqStart, reqEnd)
//                 .split('<li>')
//                 .where((part) => part.contains('</li>'))
//                 .map((part) =>
//                 part.split('</li>')[0].replaceAll(RegExp(r'<[^>]+>'), '').trim())
//                 .where((item) => item.isNotEmpty)
//                 .toList();
//             requirements.addAll(reqText);
//           }
//
//           // Nice to Have
//           if (jobDescription.contains('<strong>Nice to Have:</strong>')) {
//             final niceStart =
//                 jobDescription.indexOf('<strong>Nice to Have:</strong>') +
//                     '<strong>Nice to Have:</strong>'.length;
//             final niceText = jobDescription
//                 .substring(niceStart)
//                 .split('<li>')
//                 .where((part) => part.contains('</li>'))
//                 .map((part) =>
//                 part.split('</li>')[0].replaceAll(RegExp(r'<[^>]+>'), '').trim())
//                 .where((item) => item.isNotEmpty)
//                 .toList();
//             niceToHave.addAll(niceText);
//           }
//
//           // 🔍 Location debug
//           print('🔍 Looking for job_location_detail...');
//           final rawLocation = data['job_location_detail'] ??
//               jobDetails['job_location_detail']; // fallback if not top-level
//           print('🔍 Raw job_location_detail: $rawLocation');
//
//           String formattedLocation = 'N/A';
//           if (rawLocation is List) {
//             final locations = rawLocation
//                 .whereType<Map<String, dynamic>>()
//                 .map((loc) {
//               print('➡️ Parsing location: $loc');
//               final city = loc['city_name'] ?? '';
//               final state = loc['state_name'] ?? '';
//               return [state, city].where((e) => e.isNotEmpty).join(', ');
//             })
//                 .where((entry) => entry.isNotEmpty)
//                 .toList();
//
//             formattedLocation =
//             locations.isNotEmpty ? locations.join(' • ') : 'N/A';
//             print('✅ Final formatted location: $formattedLocation');
//           } else {
//             print('⚠️ job_location_detail is not a List');
//           }
//
//           return {
//             'title': jobDetails['title'] ?? '',
//             'company': jobDetails['company_name'] ?? '',
//             'location': formattedLocation,
//             'logoUrl': jobDetails['company_logo'] ?? '',
//             'responsibilities': responsibilities,
//             'terms': [],
//             'requirements': requirements,
//             'niceToHave': niceToHave,
//             'aboutCompany': [
//               jobDetails['company_profile']?.replaceAll(
//                 RegExp(r'<[^>]+>'),
//                 '',
//               ) ??
//                   '',
//             ],
//             'tags': (jobDetails['job_type'] != null
//                 ? [jobDetails['job_type']]
//                 : [])
//                 .where((tag) => tag.isNotEmpty)
//                 .toList(),
//             'salary': '₹${jobDetails['cost_to_company'] ?? '0'} LPA',
//             'postTime': _calculatePostTime(jobDetails['posted_on']),
//             'expiry': _calculateExpiry(jobDetails['end_date']),
//           };
//         } else {
//           throw Exception(
//               'API responded with status false or job_details is null. Message: ${data['msg'] ?? 'No message'}');
//         }
//       } catch (e) {
//         throw Exception('Failed to parse response: $e');
//       }
//     } else {
//       throw Exception(
//         'Failed to fetch Job Details: ${response.statusCode} ${response.reasonPhrase}',
//       );
//     }
//   }
//
//   static String _calculatePostTime(String? postedOn) {
//     if (postedOn == null) return 'N/A';
//     final createdOn = DateTime.parse(postedOn);
//     final now = DateTime.now();
//     final minutesAgo = now.difference(createdOn).inMinutes;
//     final hoursAgo = now.difference(createdOn).inHours;
//     return minutesAgo < 60
//         ? '$minutesAgo mins ago'
//         : hoursAgo < 24
//         ? '$hoursAgo hr ago'
//         : '${hoursAgo ~/ 24} days ago';
//   }
//
//   static String _calculateExpiry(String? endDate) {
//     if (endDate == null) return 'N/A';
//     final expiry = DateTime.parse(endDate);
//     final now = DateTime.now();
//     final daysLeft = expiry.difference(now).inDays;
//     return daysLeft > 0 ? '$daysLeft days left' : 'Expired';
//   }
// }
//
