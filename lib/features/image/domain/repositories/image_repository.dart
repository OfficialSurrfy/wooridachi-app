import 'dart:io';

abstract class ImageRepository {
  Future<String> uploadImage(File file, String path);
  Future<void> deleteImage(String imageUrl);
}
