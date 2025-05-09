import 'package:flutter/material.dart';

class TranslateButton extends StatefulWidget {
  final Function() onToggle;

  const TranslateButton({
    super.key,
    required this.onToggle,
  });

  @override
  State<TranslateButton> createState() => _TranslateButtonState();
}

class _TranslateButtonState extends State<TranslateButton> {
  bool showTranslation = false;

  void toggleTranslation() {
    setState(() {
      showTranslation = !showTranslation;
    });
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: toggleTranslation,
      child: Image.asset(
        showTranslation
            ? 'assets/images/translate_on.png'
            : 'assets/images/translate_off.png',
        width: screenWidth * 0.002427 * 60,
        height: screenHeight * 0.001093 * 60,
      ),
    );
  }
}
