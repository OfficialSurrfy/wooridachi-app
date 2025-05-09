import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close full screen on tap
          },
          child: Hero(
            tag: imageUrl, // Hero tag for smooth transition
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain, // Show the full image
            ),
          ),
        ),
      ),
    );
  }
}
