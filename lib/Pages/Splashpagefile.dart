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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

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
