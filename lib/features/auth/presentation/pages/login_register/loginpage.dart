import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/terms_and_conditions_page.dart';
import 'package:uridachi/features/auth/presentation/pages/password_change/change_password.dart';

import '../../../domain/entities/authenticate_with_email_param.dart';
import '../../providers/app_auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  void signIn() async {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    final param = AuthenticateWithEmailParam(emailController.text.trim(), passwordController.text.trim());
    await authProvider.signInWithEmailAndPassword(context, param);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildBackground(screenHeight),
            _buildLoginForm(screenHeight, screenWidth, localization),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.858331,
      decoration: const BoxDecoration(
        color: Color(0xFFECEFFF),
      ),
    );
  }

  Widget _buildLoginForm(double screenHeight, double screenWidth, AppLocalizations localization) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(51)),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04854,
          vertical: screenHeight * 0.03717,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildWelcomeText(localization),
              SizedBox(height: screenHeight * 0.00874),
              _buildGreetingText(screenWidth, localization),
              SizedBox(height: screenHeight * 0.02186),
              _buildTextField(
                controller: emailController,
                hintText: localization.email_address_hint,
                isPassword: false,
              ),
              SizedBox(height: screenHeight * 0.01311),
              _buildTextField(
                controller: passwordController,
                hintText: localization.password_hint1,
                isPassword: true,
              ),
              SizedBox(height: screenHeight * 0.03498),
              _buildSignInButton(context, screenWidth, screenHeight, localization),
              SizedBox(height: screenHeight * 0.01311),
              _buildDivider(screenWidth, localization),
              SizedBox(height: screenHeight * 0.01311),
              _buildCreateAccountButton(screenWidth, screenHeight, localization),
              SizedBox(height: screenHeight * 0.0175),
              _buildForgotPassword(screenWidth, screenHeight, localization),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(AppLocalizations localization) {
    return Text(
      localization.welcome_back,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xff582AB2),
        fontSize: 32,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.32,
      ),
    );
  }

  Widget _buildGreetingText(double screenWidth, AppLocalizations localization) {
    return SizedBox(
      width: screenWidth * 0.778,
      child: Text(
        localization.login_greeting,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, double screenWidth, double screenHeight, AppLocalizations localization) {
    return GestureDetector(
      onTap: isLoading ? null : signIn,
      child: Container(
        width: screenWidth * 0.853,
        height: screenHeight * 0.0713,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.0186),
        decoration: ShapeDecoration(
          color: isLoading ? Colors.grey : const Color(0xff582AB2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: screenWidth * 0.058,
                  height: screenHeight * 0.0262,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
              : Text(
                  localization.log_in_button,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider(double screenWidth, AppLocalizations localization) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Text(
            localization.or_text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(double screenWidth, double screenHeight, AppLocalizations localization) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TermsAndConditionsPage(),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.853,
        height: screenHeight * 0.0713,
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.0186,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: screenWidth * 0.002427,
              color: const Color(0xff582AB2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          localization.create_account_button,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff582AB2),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(double screenWidth, double screenHeight, AppLocalizations localization) {
    return SizedBox(
      width: screenWidth * 0.778,
      height: screenHeight * 0.02186,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePassword(),
            ),
          );
        },
        child: Text(
          localization.forgot_password,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.853,
      height: MediaQuery.of(context).size.height * 0.0713,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03888,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: const Color(0xFFD8DADC),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword && _isObscure,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                }
              },
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
