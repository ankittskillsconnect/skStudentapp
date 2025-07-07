import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> VerifyOtp(String email, String Otp) async {
  final url = Uri.parse(
    "https://api.skillsconnect.in/dcxqyqzqpdydfk/api/authenticate/verify-otp",
  );
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({"email": email.trim(), "otp": int.tryParse(Otp)});
  try {
    final response = await http.post(url, headers: headers, body: body);
    final responsedata = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "message": responsedata['message'] ?? "OTP verified successfully",
      };
    } else {
      return {
        "success": false,
        "message": responsedata['message'] ?? "Invalid OTP",
      };
    }
  } catch (e) {
    return {"success": false, "message": "Error verifying OTP: $e"};
  }
}
