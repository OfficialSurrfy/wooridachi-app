import 'dart:io';

abstract class ImageDatasource {
  Future<String> uploadImage(File file, String path);
  Future<void> deleteImage(String imageUrl);
}
