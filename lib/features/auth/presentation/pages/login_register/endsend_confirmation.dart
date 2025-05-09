import 'package:flutter/material.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/app/mainpage.dart';

class EndSendConfirmation extends StatelessWidget {
  const EndSendConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Scaffold(
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
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.012135, vertical: screenHeight * 0.022953),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.0360693),
              Text(
                localization.congratulations,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff582AB2),
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.30,
                ),
              ),
              Text(
                localization.registration_complete,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.30,
                ),
              ),
              SizedBox(height: screenHeight * 0.068859),
              Image.asset(
                'assets/images/check.png',
                width: screenWidth * 0.002427 * 220,
                height: screenHeight * 0.001093 * 220,
              ),
              SizedBox(height: screenHeight * 0.078696),
              SizedBox(
                width: screenWidth * 0.798483,
                child: Text(
                  localization.edit_profile_reminder,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.001093 * 210),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: screenHeight * 0.001093 * 56,
                      width: screenWidth * 0.002427 * 353,
                      color: Color(0xff582AB2),
                      child: Center(
                        child: Text(
                          localization.next_button1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
