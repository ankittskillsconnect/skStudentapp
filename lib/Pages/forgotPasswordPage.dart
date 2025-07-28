import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sk_loginscreen1/Pages/Otpfiled.dart';
import 'package:sk_loginscreen1/Utilities/Auth/VerifyOtp.dart';
import 'package:sk_loginscreen1/Utilities/Auth/forgotpasswordApi.dart';
import 'package:sk_loginscreen1/Pages/otpandresetpasswordpage.dart';

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final ForgotPasswordService _forgotServices = ForgotPasswordService();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasPopped = false;

  @override
  void initState() {
    super.initState();
    _hasPopped = false;
  }

  Future<void> _handleSendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email address"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final result = await _forgotServices.sendResetOtp(email);
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red,));

      if (result['success']) {
        _showOtpBottomSheet();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red,));
    }
  }

  Future<void> _verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter the OTP"), backgroundColor: Colors.red,));
      return;
    }

    final result = await VerifyOtp(email, otp);

    if (result["success"]) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"]),backgroundColor: Colors.red,));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpAndPasswordReset(email: email, otp: otp),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"]),backgroundColor: Colors.red,));
    }
  }

  void _goBack() {
    if (!_hasPopped && Navigator.of(context).canPop()) {
      _hasPopped = true;
      Navigator.of(context).pop();
    }
  }

  void _showOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OtpField(
                        onSubmit: (otp) => otpController.text = otp,
                        onChange: (value) => otpController.text = value,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 130,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _verifyOtp,
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Verify",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _handleSendOtp,
                            child: const Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        _goBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF003840),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          SvgPicture.asset(
                            "assets/Logo.svg",
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.09,
                          ),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Reset Password?",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Center(
                                child: Text(
                                  "Please provide an email to receive password reset instructions.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                "Enter your email address",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "example@gmail.com",
                                  prefixIcon: const Icon(Icons.mail_outline_outlined),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF003840),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Center(
                                child: SizedBox(
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.05,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleSendOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Get OTP",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.045,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _isLoading
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: screenWidth * 0.05,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              GestureDetector(
                                onTap: _goBack,
                                child: Center(
                                  child: Text(
                                    "Go Back",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
