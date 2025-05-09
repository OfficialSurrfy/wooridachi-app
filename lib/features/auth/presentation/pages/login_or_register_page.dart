import 'package:flutter/material.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/register_page.dart';

import 'login_register/loginpage.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return const LoginPage(
          //onTap: togglePages,
          );
    } else {
      return const RegisterPage(
          //onTap: togglePages,
          );
    }
  }
}
