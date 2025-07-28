import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_loginscreen1/Pages/PasswordField.dart';
import 'package:sk_loginscreen1/Pages/forgotPasswordPage.dart';
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

  bool _areFieldsValid() {
    return emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  bool _emailIsValid() {
    final email = emailController.text.trim();
    final emailRegex = RegExp(r"@");
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  Future<void> _login() async {
    if (!_areFieldsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill in all the details"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_emailIsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _loginService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      final authToken = result['token'] ?? '';
      String connectSid = result['cookie'] ?? '';

      print(' Raw connectSid from API: $connectSid');

      final match = RegExp(r'connect\.sid=([^;]+)').firstMatch(connectSid);
      if (match != null) {
        connectSid = match.group(1) ?? '';
        print(' Extracted connectSid: $connectSid');
      } else {
        print(' WARNING: connect.sid not found in cookie string.');
      }

      await prefs.setString('authToken', authToken);
      await prefs.setString('connectSid', connectSid);

      print(' Auth token and connect.sid saved to SharedPreferences.');
      print(' authToken = $authToken');
      print(' connectSid = $connectSid');

      context.read<NavigationBloc>().add(GotoHomeScreen2());
    } else {
      final message = result['message'].toString().toLowerCase();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.contains('error') || message.contains('exception')
                ? result['message']
                : "Enter correct credentials",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
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
                    //   left: screenWidth * 0.5,
                    //   child: SvgPicture.asset(
                    //     'assets/design.svg',
                    //     height: screenHeight * 0.25,
                    //     width: screenWidth * 0.5,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.025),
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
                padding: EdgeInsets.all(screenWidth * 0.06),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text("Enter your email address", style: TextStyle(fontSize: screenWidth * 0.038)),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "example@gmail.com",
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF003840)),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text("Enter password", style: TextStyle(fontSize: screenWidth * 0.038)),
                      SizedBox(height: screenHeight * 0.01),
                      PasswordField(controller: passwordController),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.read<NavigationBloc>().add(GoToForgotPassword());
                            // Navigator.push(
                            //             context,
                            //             MaterialPageRoute(builder: (_) => const ForgotpasswordPage()),
                            //           );
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.01),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.05,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
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
                                  "Login",
                                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05 ),
                                ),
                                const SizedBox(width: 8),
                                _isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    :  Icon(Icons.arrow_forward, color: Colors.white , size: screenWidth * 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account?"),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
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
