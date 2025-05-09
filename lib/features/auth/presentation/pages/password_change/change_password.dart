import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/auth/presentation/pages/password_change/verification_password.dart';
import 'package:uridachi/utils/utils.dart';
import '../../providers/app_auth_provider.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController emailController = TextEditingController();

  Future<void> doesUserExist(BuildContext context) async {
    try {
      if (emailController.text.isEmpty) {
        showSnackBar(context, "Please type an email");
        return;
      }

      QuerySnapshot user = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailController.text.trim()).get();

      if (context.mounted) {
        if (user.docs.isEmpty) {
          showSnackBar(context, "Check your email again");
        } else {
          final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
          await authProvider.sendPasswordResetEmail(context, emailController.text.trim());

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordVerificationScreen(
                  email: emailController.text.trim(),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "An error occurred. Please try again.");
      }
    }
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.001093 * 86),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    localization.change_password,
                    style: TextStyle(
                      color: Color(0xFF582AB2),
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.001093 * 190),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: emailController,
                decoration: InputDecoration(
                  hintText: localization.enter_email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF89949F),
                    ),
                  ),
                ),
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.001093 * 319),
              TextButton(
                onPressed: () async {
                  // doesUserExist(context);
                  final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
                  await authProvider.sendPasswordResetEmail(context, emailController.text.trim());
                },
                child: Container(
                  width: screenWidth * 0.002427 * 353,
                  height: screenHeight * 0.001093 * 56,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001093 * 17),
                  decoration: ShapeDecoration(
                    color: Color(0xff582AB2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localization.verify_email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
