import 'dart:convert';
import 'package:http/http.dart' as http;

class CityListApi {
  static Future<List<String>> fetchCities({
    required String cityName,
    required String stateId,
    required String authToken,
    required String connectSid,
  }) async {
    List<String> allCities = [];
    int offset = 0;
    const int limit = 10;
    bool hasMore = true;

    try {
      while (hasMore) {
        var url = Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/city/list');
        var headers = {
          'Content-Type': 'application/json',
          'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
        };

        var body = jsonEncode({
          "city_name": cityName,
          "state_id": stateId.isNotEmpty ? int.parse(stateId) : null,
          "offset": offset,
          "limit": limit,
        });
        var request = http.Request('POST', url)
          ..headers.addAll(headers)
          ..body = body;

        final response = await request.send().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            print("❌ Request timed out for city '$cityName' with state ID '$stateId', offset $offset");
            return http.StreamedResponse(Stream.value([]), 408);
          },
        );

        final resBody = await response.stream.bytesToString();
        // print("🔍 API Response for city '$cityName' with state ID '$stateId', offset $offset: $resBody");

        if (response.statusCode == 200) {
          final data = json.decode(resBody);
          if (data is Map && data['status'] == true) {
            if (data['data'] is List) {
              List options = data['data'];
              var cities = options
                  .map<String>((item) => item['name']?.toString() ?? '')
                  .where((name) => name.isNotEmpty)
                  .toList();
              allCities.addAll(cities);

              final pagination = data['pagination'];
              final total = pagination['total'] as int;
              offset += limit;
              hasMore = offset < total;
            } else if (data['data'] == false) {
              print("⚠️ No cities found for '$cityName' with state ID '$stateId'. Check token validity.");
              return allCities;
            } else {
              print("⚠️ Unexpected 'data' format, expected List or false. Response: $resBody");
              return allCities;
            }
          } else {
            print("⚠️ Invalid response structure, expected status: true. Response: $resBody");
            return allCities;
          }
        } else {
          print("❌ API failed for city '$cityName' with state ID '$stateId': ${response.statusCode} - ${response.reasonPhrase}");
          print("Response body: $resBody");
          return allCities;
        }
      }
      return allCities;
    } catch (e) {
      print("❌ Error fetching cities for '$cityName' with state ID '$stateId': $e");
      return allCities;
    }
  }
}