import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'image_datasource.dart';

class ImageDatasourceImpl implements ImageDatasource {
  final FirebaseStorage _firebaseStorage;

  ImageDatasourceImpl(this._firebaseStorage);

  @override
  Future<String> uploadImage(File file, String path) async {
    try {
      final storageRef = _firebaseStorage.ref().child(path);
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final storageRef = _firebaseStorage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      rethrow;
    }
  }
}
