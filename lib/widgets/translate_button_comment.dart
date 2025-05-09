import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslateButtonComment extends StatefulWidget {
  final String description;
  final Function(String) onTranslated;

  const TranslateButtonComment({
    super.key,
    required this.description,
    required this.onTranslated,
  });

  @override
  State<TranslateButtonComment> createState() => _TranslateButtonCommentState();
}

class _TranslateButtonCommentState extends State<TranslateButtonComment> {
  final translator = GoogleTranslator();
  String? translatedDescription;
  String? translatedTitle;
  bool showTranslation = false;

  final RegExp japanese = RegExp(r'/[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g; ');
  final RegExp korean = RegExp(r'^[\uAC00-\uD7AF]+');

  Future<void> translate() async {
    setState(() {
      showTranslation = !showTranslation;
    });

    if (showTranslation) {
      if (japanese.hasMatch(widget.description)) {
        translatedDescription = (await translator.translate(widget.description, to: "ko")).text;
      } else if (korean.hasMatch(widget.description)) {
        translatedDescription = (await translator.translate(widget.description, to: "ja")).text;
      } else {
        translatedDescription = widget.description;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: translate,
      child: Image.asset(
        showTranslation ? 'assets/images/translate_on.png' : 'assets/images/translate_off.png',
        width: screenWidth * 0.002427 * 25,
        height: screenHeight * 0.001093 * 25,
      ),
    );
  }
}
