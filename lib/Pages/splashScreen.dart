import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/Pages/Splashpagefile.dart';
import '../blocpage/bloc_logic.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 3), () {
    //   context.read<NavigationBloc>().add(SplashToLogin());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003840),
      body: SplashPageFile(),
    );
  }
}
