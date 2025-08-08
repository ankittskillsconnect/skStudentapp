import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';


class SplashPageFile extends StatefulWidget {
  const SplashPageFile({super.key});


  @override
  State<SplashPageFile> createState() => _SplashPageFileState();

}

class _SplashPageFileState extends State<SplashPageFile> {
  bool _internetToastShown = false;
  bool _snackBarShown = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
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
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: cooldownSeconds),
      ),
    );
    Future.delayed(Duration(seconds: cooldownSeconds), () {
      _snackBarShown = false;
    });
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    //throw to login if no internet present and clear token
    // if (!await _hasInternetConnection()) {
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.remove('auth_token');
    //   if (mounted) {
    //     if (!_internetToastShown) {
    //       _internetToastShown = true;
    //       _showSnackBarOnce(context, "No internet. Login again.");
    //     }
    //     context.read<NavigationBloc>().add(SplashToLogin());
    //   }
    //   return;
    // }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.read<NavigationBloc>().add(GotoHomeScreen2());
    } else {
      context.read<NavigationBloc>().add(SplashToLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 100,
          child: SvgPicture.asset(
            'assets/design.svg',
            height: 370,
            width: 288,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              SvgPicture.asset("assets/Logo.svg", width: 193, height: 64),
            ],
          ),
        ),
      ],
    );
  }
}
