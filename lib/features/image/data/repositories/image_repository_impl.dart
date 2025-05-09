import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../domain/exceptions/image_exception.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDatasource _imageDatasource;

  ImageRepositoryImpl(this._imageDatasource);

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      await _imageDatasource.deleteImage(imageUrl);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadImage(File file, String path) async {
    try {
      final compressedFile = await _compressImage(file, 50);
      return await _imageDatasource.uploadImage(compressedFile, path);
    } catch (e) {
      rethrow;
    }
  }

  Future<File> _compressImage(File file, int quality) async {
    try {
      final compressedFilePath = '${file.path}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        compressedFilePath,
        quality: quality,
      );
      if (compressedFile == null) {
        throw ImageCompressionFailedException();
      }
      return File(compressedFile.path);
    } catch (e) {
      rethrow;
    }
  }
}
