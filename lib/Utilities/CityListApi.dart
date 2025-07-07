import 'dart:convert';
import 'package:http/http.dart' as http;

class CityListApi {
  static Future<List<String>> fetchCities(String cityName, String token) async {
    try {
      final url = Uri.parse(
        'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/city/list',
      );
      final headers = {
        'Content-Type': 'application/json',
        'Cookie':
        'authToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTgyMDksImVtYWlsIjoibWFoZXNoQGFwcHRyb2lkLmNvbSIsInVzZXJfdHlwZSI6Nywic291cmNlIjoibXlzcWwiLCJjb21wYW55X2lkIjoxOTUsImNvbXBhbnlfbmFtZSI6Ik5pdmEgQnVwYSIsInBhY2thZ2VfaWQiOjQsInBhY2thZ2VfdmFsaWRpdHlfaWQiOjQ5LCJzdGFydF9kYXRlIjoiMjAyMy0xMi0wM1QxODozMDowMC4wMDBaIiwiZW5kX2RhdGUiOiIyMDI1LTA3LTMwVDE4OjMwOjAwLjAwMFoiLCJwYWNrYWdlX3ZhbGlkdHkiOiJNb250aGx5IiwidHJhbnNhY3Rpb25faWQiOiI5ODAwMDAwMDAwMDAwOTAwMDkiLCJwYXltZW50X2lkIjpudWxsLCJjb3Vwb25faWQiOm51bGwsInByZW1pdW1fY29sbGVnZSI6bnVsbCwiY2xpZW50X3R5cGUiOiIiLCJpYXQiOjE3NTE4NzE2NzksImV4cCI6MTc1MjA0NDQ3OX0.T-c3T3fPaubsNeGqO1gu0QrwsgKcdFwBn2ZU_VzRNn4; connect.sid=s%3A90I8VK0ssLCW9DjFq4xSLrkDEI7xUgCG.JFNw9cZG8Txw07rqZ6gs7K8bGpm4pMApT7Yu9FqqjbY',
      };

      final body = jsonEncode({
        "city_name": cityName,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cities = data['data'];

        return cities.map<String>((city) => city['city'] as String).toList();
      } else {
        print('Failed to fetch cities: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }
}
