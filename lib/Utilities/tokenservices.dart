// import 'package:shared_preferences/shared_preferences.dart';
//
// class TokenService {
//   static Future<String?> getAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//
//     if (token == null || token.isEmpty) {
//       print('❌ No token found in SharedPreferences.');
//       return null;
//     } else {
//       print('🔐 Token loaded from SharedPreferences: ${token.substring(0, 20)}...');
//       return token;
//     }
//   }
// }
