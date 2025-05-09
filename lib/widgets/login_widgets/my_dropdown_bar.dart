import 'package:flutter/material.dart';

class MyDropdownBar extends StatelessWidget {
  final String? defaultValue;
  final List<String> options;
  final void Function(String?) onChanged;
  final String hintText;

  const MyDropdownBar({
    super.key,
    this.defaultValue,
    required this.options,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.002427 * 353,
      height: screenHeight * 0.001093 * 62,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001093 * 18),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: screenWidth * 0.002427 * 1, color: Color(0xFF89949F)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: defaultValue == null
              ? Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.002427 * 16),
                  child: Text(
                      hintText, style: TextStyle(color: Colors.grey),), // Show hint only when defaultValue is null
                )
              : null,
          value: defaultValue,
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.002427 * 16),
                child: Text(value, style: TextStyle(color: Colors.black),),
              ),
            );
          }).toList(),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          dropdownColor: Colors.grey.shade200,
          style: TextStyle(color: Colors.grey[500], fontSize: 16),
        ),
      ),
    );
  }
}
