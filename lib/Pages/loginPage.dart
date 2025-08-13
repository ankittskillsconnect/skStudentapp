import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_loginscreen1/Pages/PasswordField.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../Utilities/auth/LoginUserApi.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final loginUser _loginService = loginUser();
  bool _internetToastShown = false;
  bool _snackBarShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
      emailController.clear();
      passwordController.clear();
      setState(() {
        _isLoading = false;
      });
    });

    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showSnackBarOnce(BuildContext context, String message, {int cooldownSeconds = 3}) {
    if (_snackBarShown) return;

    _snackBarShown = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 12.sp)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: cooldownSeconds),
      ),
    );

    Future.delayed(Duration(seconds: cooldownSeconds), () {
      _snackBarShown = false;
    });
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showSnackBarOnce(context, "Fill in all the details");
      return;
    }

    if (email.isEmpty) {
      _showSnackBarOnce(context, "Email is incorrect");
      return;
    }

    if (password.isEmpty) {
      _showSnackBarOnce(context, "Password is required");
      return;
    }

    if (!await _hasInternetConnection()) {
      if (!_internetToastShown) {
        _internetToastShown = true;
        _showSnackBarOnce(context, "No internet available");
        Future.delayed(const Duration(seconds: 3), () {
          _internetToastShown = false;
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final result = await _loginService.login(
      email,
      password,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      final authToken = result['token'] ?? '';
      String connectSid = result['cookie'] ?? '';

      // print(' Raw connectSid from API: $connectSid');

      final match = RegExp(r'connect\.sid=([^;]+)').firstMatch(connectSid);
      if (match != null) {
        connectSid = match.group(1) ?? '';
        print(' Extracted connectSid: $connectSid');
      } else {
        print(' WARNING: connect.sid not found in cookie string.');
      }

      await prefs.setString('authToken', authToken);
      await prefs.setString('connectSid', connectSid);

      context.read<NavigationBloc>().add(GotoHomeScreen2());
    } else {
      final message = result['message']?.toString().toLowerCase() ?? '';

      if (message.contains('email') || message.contains('e-mail') || message.contains('username')) {
        _showSnackBarOnce(context, "Email is incorrect");
      } else if (message.contains('password')) {
        _showSnackBarOnce(context, "Password is incorrect");
      } else {
        _showSnackBarOnce(
          context,
          message.contains('error') || message.contains('exception')
              ? result['message'].toString()
              : "Enter correct credentials",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        // if (state is NavigatetoForgotPassword) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => const ForgotpasswordPage()),
        //   );
        // }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF003840),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: SafeArea(
                child: Stack(
                  children: [
                    // Positioned(
                    //   top: 0,
                    //   left: 195.w,
                    //   child: SvgPicture.asset(
                    //     'assets/design.svg',
                    //     height: 200.h,
                    //     width: 195.w,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.h),
                          SvgPicture.asset(
                            "assets/Logo.svg",
                            width: 300.w,
                            height: 70.h,
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
                padding: EdgeInsets.all(22.w),
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
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text("Enter your email address", style: TextStyle(fontSize: 14.sp)),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "example@gmail.com",
                          prefixIcon: Icon(Icons.email_outlined, size: 20.w),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.r),
                            borderSide: const BorderSide(color: Color(0xFF003840)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text("Enter password", style: TextStyle(fontSize: 14.sp)),
                      SizedBox(height: 8.h),
                      PasswordField(controller: passwordController),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.read<NavigationBloc>().add(GoToForgotPassword());
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (_) => const ForgotpasswordPage()),
                            // );
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 140.w,
                          height: 40.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003840),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                ),
                                SizedBox(width: 7.w),
                                _isLoading
                                    ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.7.w,
                                  ),
                                )
                                    : Icon(Icons.arrow_forward, color: Colors.white, size: 18.w),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don’t have an account?", style: TextStyle(fontSize: 12.sp)),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}