import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class UpdatePostUsecase {
  final PostRepository _postRepository;

  UpdatePostUsecase(this._postRepository);

  Future<void> call(PostEntity post) async {
    try {
      await _postRepository.updatePost(post);
    } catch (e) {
      rethrow;
    }
  }
}
