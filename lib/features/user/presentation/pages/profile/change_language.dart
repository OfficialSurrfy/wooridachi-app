import 'package:flutter/material.dart';
import '../../../../../main.dart';
import 'package:uridachi/l10n/app_localizations.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  late String _selectedLanguage;
  String checkOrUncheck = 'assets/images/unchecked_icon.png';
  String checkOrUncheck2 = 'assets/images/unchecked_icon.png';
  String checkOrUncheck3 = 'assets/images/unchecked_icon.png';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context);
    _selectedLanguage = currentLocale.languageCode;
    _updateCheckIcons(); // Initialize check icons based on the current locale
  }

  void _updateCheckIcons() {
    setState(() {
      checkOrUncheck = _selectedLanguage == 'ko' ? 'assets/images/checked_icon.png' : 'assets/images/unchecked_icon.png';
      checkOrUncheck2 = _selectedLanguage == 'ja' ? 'assets/images/checked_icon.png' : 'assets/images/unchecked_icon.png';
      checkOrUncheck3 = _selectedLanguage == 'en' ? 'assets/images/checked_icon.png' : 'assets/images/unchecked_icon.png';
    });
  }

  void _confirmLanguageChange() {
    Locale newLocale;
    if (_selectedLanguage == 'ja') {
      newLocale = const Locale('ja');
    } else if (_selectedLanguage == 'en') {
      newLocale = const Locale('en');
    } else {
      newLocale = const Locale('ko');
    }

    MyApp.of(context)?.setLocale(newLocale);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFECEFFF),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.001093 * 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          localization.change_language,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: screenHeight * 0.19674,
                decoration: const BoxDecoration(
                  color: Color(0xFFECEFFF),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.2186,
              ),
              Positioned(
                left: screenWidth * 0.361,
                top: screenHeight * 0.107,
                child: Container(
                  height: screenHeight * 0.123509,
                  width: screenWidth * 0.274251,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.378,
                top: screenHeight * 0.1093,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: SizedBox(
                      width: screenWidth * 0.002427 * 90,
                      height: screenHeight * 0.001093 * 90,
                      child: FittedBox(
                        child: Image.asset(
                          'assets/images/change.png',
                          width: screenWidth * 0.002427 * 80,
                          height: screenHeight * 0.001093 * 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.001093 * 66),
          Row(
            children: [
              SizedBox(width: screenWidth * 0.002427 * 66),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'ko';
                    _updateCheckIcons();
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      checkOrUncheck,
                      width: screenWidth * 0.002427 * 30,
                      height: screenHeight * 0.001093 * 30,
                    ),
                    SizedBox(width: screenWidth * 0.002427 * 12),
                    Text(
                      localization.kr_korean,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.001093 * 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: screenWidth * 0.002427 * 66),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'ja';
                    _updateCheckIcons();
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      checkOrUncheck2,
                      width: screenWidth * 0.002427 * 30,
                      height: screenHeight * 0.001093 * 30,
                    ),
                    SizedBox(width: screenWidth * 0.002427 * 12),
                    Text(
                      localization.jp_japanese,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.001093 * 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: screenWidth * 0.002427 * 66),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'en';
                    _updateCheckIcons();
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      checkOrUncheck3,
                      width: screenWidth * 0.002427 * 30,
                      height: screenHeight * 0.001093 * 30,
                    ),
                    SizedBox(width: screenWidth * 0.002427 * 12),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: localization.us_english,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: localization.restricted,
                            style: TextStyle(
                              color: const Color(0xFFFF0C0C),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.001093 * 100),
          TextButton(
            onPressed: _confirmLanguageChange,
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
                localization.apply_changes,
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
    );
  }
}
