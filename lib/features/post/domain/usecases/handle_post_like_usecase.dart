import 'package:uuid/uuid.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/post_like_entity.dart';
import '../exceptions/post_like_exceptions.dart';
import '../repositories/post_like_repository.dart';

class HandlePostLikeUsecase {
  final AuthRepository _authRepository;
  final PostLikeRepository _postLikeRepository;
  final Uuid _uuid;

  HandlePostLikeUsecase(
    this._authRepository,
    this._postLikeRepository,
    this._uuid,
  );

  Future<void> call(String postId, bool isLiked) async {
    final userId = _authRepository.getCurrentUserId();

    try {
      if (!isLiked) {
        final likeId = _uuid.v4();
        final createdAt = DateTime.now();
        final like = PostLikeEntity(
          id: likeId,
          postId: postId,
          userId: userId,
          createdAt: createdAt,
        );

        await _postLikeRepository.likePost(like);
      } else {
        await _postLikeRepository.unlikePost(postId, userId);
      }
    } catch (e) {
      if (!isLiked) {
        throw PostLikeAddException();
      } else {
        throw PostLikeDeleteException();
      }
    }
  }
}
