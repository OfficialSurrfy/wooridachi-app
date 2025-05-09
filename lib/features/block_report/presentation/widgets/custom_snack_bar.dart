import 'package:flutter/material.dart';

class CustomSnackBar {
  final String message;
  const CustomSnackBar({
    required this.message,
  });

  static const Color purpleColor = Color(0xFF4D27C7);

  static void show(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(build(message));
  }

  static SnackBar build(String message) {
    return SnackBar(
      backgroundColor: purpleColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
