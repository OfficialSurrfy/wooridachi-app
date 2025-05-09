import '../../../image/domain/repositories/image_repository.dart';
import '../repositories/post_repository.dart';

class DeletePostUsecase {
  final PostRepository _postRepository;
  final ImageRepository _imageRepository;

  DeletePostUsecase(this._postRepository, this._imageRepository);

  Future<void> call(String postId) async {
    try {
      final post = await _postRepository.getPostById(postId);
      if (post.imageUrls != null) {
        for (var imageUrl in post.imageUrls!) {
          await _imageRepository.deleteImage(imageUrl);
        }
      }

      await _postRepository.deletePost(postId);
    } catch (e) {
      rethrow;
    }
  }
}
