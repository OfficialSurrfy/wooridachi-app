import 'package:flutter/material.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/register_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uridachi/l10n/app_localizations.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  bool checkedValue = false;
  bool checkedValue2 = false;
  bool checkedValue3 = false;
  bool checkedValue4 = false;
  bool checkedValue5 = false;
  bool _allFilled = false;

  void _updateAllFilled() {
    setState(() {
      _allFilled = checkedValue2 && checkedValue3 && checkedValue5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    Future<void> launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.001093 * 26),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.002427 * 25, top: screenHeight * 0.001093 * 50, bottom: screenHeight * 0.001093 * 40),
                child: Text(
                  localization.terms_agreement,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xff582AB2)),
                ),
              ),
              SizedBox(
                child: CheckboxListTile(
                  title: Text(
                    localization.agree_to_all_terms,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: checkedValue,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkedValue = newValue!;
                      checkedValue2 = newValue;
                      checkedValue3 = newValue;
                      checkedValue4 = newValue;
                      checkedValue5 = newValue;
                    });
                    _updateAllFilled();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 20.0),
                child: Divider(
                  thickness: 1.8,
                ),
              ),
              SizedBox(
                width: screenWidth,
                child: CheckboxListTile(
                  title: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: localization.service_terms_agreement,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(
                              text: '\n${localization.mandatory}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.002427 * 12),
                        child: GestureDetector(
                            onTap: () {
                              launchURL('https://citrine-scent-fa8.notion.site/123d64f786f98064b58ec2674b3ee327');
                            },
                            child: Container(
                                height: 23,
                                width: 67,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Center(
                                  child: Text(
                                    localization.view_details,
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ))),
                      )
                    ],
                  ),
                  value: checkedValue2,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkedValue2 = newValue!;
                    });
                    _updateAllFilled();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(
                width: screenWidth,
                child: CheckboxListTile(
                  title: Row(
                    children: [
                      RichText(
                          text: TextSpan(text: localization.privacy_policy_agreement, style: TextStyle(color: Colors.black, fontSize: 16), children: [
                        TextSpan(
                          text: '\n${localization.mandatory}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.002427 * 12),
                        child: GestureDetector(
                            onTap: () {
                              launchURL('https://citrine-scent-fa8.notion.site/126d64f786f980cabc56cc6477616c26');
                            },
                            child: Container(
                                height: screenHeight * 0.001093 * 23,
                                width: screenWidth * 0.002427 * 67,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Center(
                                  child: Text(
                                    localization.view_details,
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ))),
                      )
                    ],
                  ),
                  value: checkedValue3,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkedValue3 = newValue!;
                    });
                    _updateAllFilled();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(
                width: screenWidth,
                child: CheckboxListTile(
                  title: Text(
                    localization.advertising_consent,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  value: checkedValue4,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkedValue4 = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(
                width: screenWidth,
                child: CheckboxListTile(
                  title: RichText(
                      text: TextSpan(text: localization.age_confirmation, style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: localization.mandatory, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                  ])),
                  value: checkedValue5,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkedValue5 = newValue!;
                    });
                    _updateAllFilled();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (_allFilled) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.002427 * 25, bottom: screenHeight * 0.001093 * 50),
              child: Container(
                width: screenWidth * 0.002427 * 353,
                height: screenHeight * 0.001093 * 56,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001093 * 17),
                decoration: ShapeDecoration(
                  color: _allFilled ? const Color(0xff582AB2) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: screenWidth * 0.002427 * 1, color: const Color(0xFF737373)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    localization.create_account_button,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
