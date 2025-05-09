import 'package:uuid/uuid.dart';

import '../entities/comment_like_entity.dart';
import '../repositories/comment_like_repository.dart';

class HandleCommentLikeUsecase {
  final CommentLikeRepository _repository;

  HandleCommentLikeUsecase({
    required CommentLikeRepository repository,
  }) : _repository = repository;

  Future<void> call(String postId, String commentId, String userId, bool isCurrentlyLiked) async {
    if (isCurrentlyLiked) {
      await _repository.unlikeComment(postId, commentId, userId);
    } else {
      final like = CommentLikeEntity(
        id: const Uuid().v4(),
        postId: postId,
        commentId: commentId,
        userId: userId,
        createdAt: DateTime.now(),
      );
      await _repository.likeComment(like);
    }
  }
}
