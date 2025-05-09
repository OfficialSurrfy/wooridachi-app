import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/loginpage.dart';
import '../../../../../utils/utils.dart';
import 'package:uridachi/l10n/app_localizations.dart';

class PasswordVerificationScreen extends StatefulWidget {
  final String email;

  const PasswordVerificationScreen({super.key, required this.email});

  @override
  State<PasswordVerificationScreen> createState() => _PasswordVerificationScreenState();
}

class _PasswordVerificationScreenState extends State<PasswordVerificationScreen> {
  bool _isSending = false;
  Timer? _cooldownTimer;
  int _cooldownTime = 60; //seconds
  bool _canResend = true;

  void startCooldown() {
    setState(() {
      _canResend = false;
      _cooldownTime = 60;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownTime == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _cooldownTime--;
        });
      }
    });
  }

  Future<void> sendVerification() async {
    if (!_canResend) return;
    setState(() {
      _isSending = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      showSnackBar(context, 'Verification email resent.');
      startCooldown();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        showSnackBar(context, 'Too many requests. Please try again later.');
      } else {
        showSnackBar(context, 'Error sending verification email: ${e.message}');
      }
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 5, vertical: screenHeight * 0.001093 * 21),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      localization.next_button1,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.30000001192092896),
                        fontSize: 16,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.001093 * 33),
              Text(
                localization.verification_email_sent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.30,
                ),
              ),
              SizedBox(height: screenHeight * 0.001093 * 63),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/email_background.png',
                    width: screenWidth * 0.002427 * 230,
                    height: screenHeight * 0.001093 * 194,
                  ),
                  Image.asset(
                    'assets/images/email.png',
                    width: screenWidth * 0.002427 * 125,
                    height: screenHeight * 0.001093 * 120,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.001093 * 72),
              SizedBox(
                width: screenWidth * 0.002427 * 329,
                child: Text(
                  localization.email_sent_to,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7300000190734863),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
              Text(
                localization.verify_and_proceed,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: screenHeight * 0.001093 * 123),
              TextButton(
                onPressed: _canResend
                    ? () {
                        sendVerification();
                      }
                    : null,
                child: Container(
                  width: screenWidth * 0.002427 * 353,
                  height: screenHeight * 0.001093 * 56,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001093 * 17),
                  decoration: ShapeDecoration(
                    color: _canResend ? Colors.black : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _canResend ? 'Resend mail' : 'Wait $_cooldownTime seconds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
