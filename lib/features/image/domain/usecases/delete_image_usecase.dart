import '../repositories/image_repository.dart';

class DeleteImageUsecase {
  final ImageRepository _imageRepository;

  DeleteImageUsecase(this._imageRepository);

  Future<void> call(String imageUrl) async {
    try {
      await _imageRepository.deleteImage(imageUrl);
    } catch (e) {
      rethrow;
    }
  }
}
