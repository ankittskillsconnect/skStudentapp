import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sk_loginscreen1/Utilities/Auth/changePasswordApi.dart';

class OtpAndPasswordReset extends StatefulWidget {
  final String email;
  final String otp;

  const OtpAndPasswordReset({super.key, required this.email, required this.otp});

  @override
  State<OtpAndPasswordReset> createState() => _OtpAndPasswordResetState();
}

class _OtpAndPasswordResetState extends State<OtpAndPasswordReset> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _resetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("Both fields are required");
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnackbar("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    final result = await PasswordServices.resetPassword(
      email: widget.email,
      otp: widget.otp,
      password: newPassword,
    );

    setState(() => _isLoading = false);

    _showSnackbar(result['message']);
    if (result['success']) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003840),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 200,
                    child: SvgPicture.asset(
                      'assets/design.svg',
                      height: 200,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        SvgPicture.asset("assets/Logo.svg", width: 193, height: 64),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Enter New Password",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text("New Password"),
                    const SizedBox(height: 8),
                    _buildPasswordField(_newPasswordController, "Enter new password"),
                    const SizedBox(height: 20),
                    const Text("Confirm Password"),
                    const SizedBox(height: 8),
                    _buildPasswordField(_confirmPasswordController, "Confirm password"),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 190,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _resetPassword,
                          label: Text(
                            _isLoading ? "Please wait..." : "Reset Password",
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          icon: const Icon(Icons.lock_reset, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF003840)),
        ),
      ),
    );
  }
}
