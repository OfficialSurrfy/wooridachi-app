import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const TextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.only(
        left: screenWidth * 0.002427 * 15,
        bottom: screenHeight * 0.001093 * 15,
      ),
      margin: EdgeInsets.only(
          left: screenWidth * 0.002427 * 20,
          right: screenWidth * 0.002427 * 20,
          top: screenHeight * 0.001093 * 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.settings),
                color: Colors.grey[400],
              ),
            ],
          ),
          Text(text),
        ],
      ),
    );
  }
}
