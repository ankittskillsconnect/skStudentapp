import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/AccountScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/Myaccount/MyAccount.dart';
import 'package:sk_loginscreen1/BottamTabScreens/ContactsTab/ContactsScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobScreenBT.dart';
import 'package:sk_loginscreen1/Pages/splashScreen.dart';
import 'package:sk_loginscreen1/Pages/forgotPasswordPage.dart';
import 'package:sk_loginscreen1/Utilities/auth/LoginUserApi.dart';
import 'package:sk_loginscreen1/blocpage/BookmarkBloc/bookmarkLogic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import 'package:sk_loginscreen1/BottamTabScreens/Interveiwtab/InterviewScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/homeScreen.dart';
import 'package:sk_loginscreen1/Pages/loginPage.dart';
import 'ProfileLogic/ProfileEvent.dart';
import 'ProfileLogic/ProfileLogic.dart';
import 'blocpage/jobFilterBloc/jobFilter_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider(create: (_) => ProfileBloc()..add(LoadProfileData())),
        BlocProvider(create: (_) => BookmarkBloc()),
        BlocProvider(create: (_) => JobFilterBloc()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: MainApp()),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isCheckingToken = true;
  bool _isLoggedIn = false;
  bool _showSplashScreen = true;

  @override
  void initState() {
    super.initState();
    _showSplashScreenWithDelay();
  }

  Future<void> _showSplashScreenWithDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _showSplashScreen = false;
    });
    _checkToken();
  }

  Future<void> _checkToken() async {
    final loginService = loginUser();
    final token = await loginService.getToken();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = token != null;
      _isCheckingToken = false;
    });

    if (_isLoggedIn) {
      context.read<NavigationBloc>().add(GotoHomeScreen2());
    } else {
      context.read<NavigationBloc>().add(GobackToLoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state is NavigatetoForgotPassword) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ForgotpasswordPage()),
          );
        } else if (state is NavigateToLoginPage ||
            state is NavigateBacktoLoginin) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state is NavigateToMyAccount) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyAccount()),
          ).then((_) {
            context.read<NavigationBloc>().add(GoToAccountScreen2());
          });
        }
      },
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (_showSplashScreen) return const SplashScreen();
          if (_isCheckingToken) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is NavigateToLoginPage ||
              state is NavigateBacktoLoginin ||
              state is NavigatetoForgotPassword) {
            return const Loginpage();
          } else if (state is NavigateToHomeScreen2) {
            return const HomeScreen2();
          } else if (state is NavigateToJobSecreen2) {
            return const Jobscreenbt();
          } else if (state is NavigateToInterviewScreen) {
            return const InterviewScreen();
          } else if (state is NavigateToContactsScreen) {
            return const Contactsscreen();
          } else if (state is NavigateToAccountScreen) {
            return const AccountScreen();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
