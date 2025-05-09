import 'package:flutter/material.dart';

class LanguageToggleButton extends StatefulWidget {
  final bool isKoreanSelected;
  final ValueChanged<bool> onToggle;

  const LanguageToggleButton({
    super.key,
    required this.isKoreanSelected,
    required this.onToggle,
  });

  @override
  _LanguageToggleButtonState createState() => _LanguageToggleButtonState();
}

class _LanguageToggleButtonState extends State<LanguageToggleButton> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.002427 * 87,
      height: screenHeight * 0.001093 * 35,
      decoration: BoxDecoration(
        color: Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Color.fromARGB(255, 91, 48, 208),
            width: screenWidth * 0.002427 * 1.5),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: widget.isKoreanSelected
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: Duration(milliseconds: 300),
            child: Container(
              width: screenWidth * 0.002427 * 47,
              height: screenHeight * 0.001093 * 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onToggle(true);
                  },
                  child: Center(
                    child: Text(
                      "KOR",
                      style: TextStyle(
                        color: widget.isKoreanSelected
                            ? Color(0xfff582ad2)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onToggle(false); // Notify parent of language change
                  },
                  child: Center(
                    child: Text(
                      "JPN",
                      style: TextStyle(
                        color: widget.isKoreanSelected
                            ? Colors.white
                            : Color(0xfff582ad2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
