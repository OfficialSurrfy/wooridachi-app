import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/endsend_confirmation.dart';
import '../../../../../utils/utils.dart';

class EmailVerificationScreen extends StatefulWidget {
  final Future<String> Function() signUpUser;

  const EmailVerificationScreen({super.key, required this.signUpUser});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  int _attemptCount = 0;
  final int _maxAttempts = 5;
  bool _isSending = false;
  String? userEmail = '';
  Timer? _cooldownTimer;
  int _cooldownTime = 60;
  bool _canResend = true;

  Future<void> reloadUser() async {
    if (_attemptCount >= _maxAttempts) {
      showSnackBar(context, 'Too many attempts. Please try again later.');
      return;
    }

    try {
      _attemptCount++;
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified && mounted) {
        String signUpResult = await widget.signUpUser();
        if (signUpResult == "success") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EndSendConfirmation()),
            (Route<dynamic> route) => false,
          );
        } else {
          showSnackBar(context, 'Sign-up process failed. Please try again.');
        }
      } else {
        if (mounted) {
          showSnackBar(context, 'Please verify your email to continue.');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error reloading user: $e');
      }
    } finally {
      if (_attemptCount < _maxAttempts) {
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

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

  Future<void> sendVerification(String email) async {
    if (!_canResend) return;

    setState(() {
      _isSending = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      if (kDebugMode) {
        print('Verification email sent to: $email');
      }
      showSnackBar(context, 'Verification email sent.');
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

  Future<void> getEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.001093 * 26),
            child: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.001093 * 22),
              child: TextButton(
                onPressed: () async {
                  await reloadUser();
                },
                child: Text(
                  localization.next_button1,
                  style: TextStyle(
                    color: const Color(0xff582AB2),
                    fontSize: 16,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 5, vertical: screenHeight * 0.001093 * 21),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.001093 * 33),
              Text(
                localization.verification_email_sent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.30,
                ),
              ),
              SizedBox(height: screenHeight * 0.001093 * 63),
              Container(
                width: screenWidth * 0.002427 * 270,
                height: screenHeight * 0.001093 * 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/email_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/email.png',
                    width: screenWidth * 0.002427 * 125,
                    height: screenHeight * 0.001093 * 120,
                    color: Color(0xff582AB2),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.001093 * 72),
              SizedBox(
                width: screenWidth * 0.002427 * 329,
                child: Text(
                  localization.email_sent_to,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                userEmail!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff582AB2),
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
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: screenHeight * 0.001093 * 123),
              TextButton(
                onPressed: _canResend
                    ? () {
                        sendVerification(userEmail!);
                      }
                    : null,
                child: Container(
                  width: screenWidth * 0.002427 * 353,
                  height: screenHeight * 0.001093 * 56,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001093 * 17),
                  decoration: ShapeDecoration(
                    color: _canResend ? const Color(0xff582AB2) : Colors.grey,
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
