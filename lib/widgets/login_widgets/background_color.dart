// background_color.dart

import 'package:flutter/material.dart';

class BackgroundColor {
  static BoxDecoration gradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFDEF6FF), // Light blue at the bottom
          Color(0xFFFFFFFF), // White at the top
        ],
        stops: [0, 1],
        begin: Alignment.bottomCenter, // Align the gradient at the bottom
        end: Alignment.topCenter, // Align the gradient at the top
      ),
    );
  }
}
