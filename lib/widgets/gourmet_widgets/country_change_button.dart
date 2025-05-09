import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CountryChangingButton extends StatefulWidget {
  final String place;
  final double size;
  final bool isSelected;
  final VoidCallback onPressed;

  const CountryChangingButton({
    super.key,
    required this.place,
    required this.size,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  _CountryChangingButtonState createState() => _CountryChangingButtonState();
}

class _CountryChangingButtonState extends State<CountryChangingButton> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(right: screenWidth * 0.002427 * 10),
      width: widget.size,
      height: screenHeight * 0.001093 * 30,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            widget.isSelected ? primaryColor : Colors.white,
          ),
          side: WidgetStateProperty.all(const BorderSide(
            color: primaryColor,
            width: 1.0,
          )),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        child: Text(
          widget.place,
          style: TextStyle(
            color: widget.isSelected ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }
}
