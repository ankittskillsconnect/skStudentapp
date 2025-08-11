import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sk_loginscreen1/Utilities/Auth/changePasswordApi.dart';

import 'NewpasswordFiled.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(fontSize: 12.sp)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

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
                    left: 180.w,
                    child: SvgPicture.asset(
                      'assets/design.svg',
                      height: 180.h,
                      width: 220.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 17.h),
                        SvgPicture.asset("assets/Logo.svg", width: 170.w, height: 55.h),
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
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Enter New Password",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 35.h),
                    Text("New Password", style: TextStyle(fontSize: 14.sp)),
                    SizedBox(height: 7.h),
                    NewPasswordField(controller: _newPasswordController),
                    SizedBox(height: 17.h),
                    Text("Confirm Password", style: TextStyle(fontSize: 14.sp)),
                    SizedBox(height: 7.h),
                    NewPasswordField(controller: _confirmPasswordController),
                    SizedBox(height: 35.h),
                    Center(
                      child: SizedBox(
                        width: 165.w,
                        height: 45.h,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _resetPassword,
                          label: Text(
                            _isLoading ? "Please wait..." : "Reset Password",
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                          icon: Icon(Icons.lock_reset, color: Colors.white, size: 20.w),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
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
}