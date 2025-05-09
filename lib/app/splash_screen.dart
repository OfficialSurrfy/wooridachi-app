import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:uridachi/app/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isAnimationComplete = true;
    });
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (_isAnimationComplete) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/images/splash_screen.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
