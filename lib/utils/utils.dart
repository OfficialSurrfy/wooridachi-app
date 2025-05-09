import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showSnackBar(BuildContext context, String? text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text!),
    ),
  );
}

Future<List<Uint8List>> pickImages(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  final List<XFile> files = await imagePicker.pickMultiImage();

  List<Uint8List> images = [];

  for (XFile file in files) {
    Uint8List imageData = await file.readAsBytes();
    images.add(imageData);
  }

  return images;
}
