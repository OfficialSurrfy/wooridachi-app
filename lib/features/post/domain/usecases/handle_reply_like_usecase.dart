import 'package:uuid/uuid.dart';

import '../entities/reply_like_entity.dart';
import '../repositories/reply_like_repository.dart';

class HandleReplyLikeUsecase {
  final ReplyLikeRepository _repository;

  HandleReplyLikeUsecase({
    required ReplyLikeRepository repository,
  }) : _repository = repository;

  Future<void> call(String postId, String commentId, String replyId, String userId, bool isCurrentlyLiked) async {
    if (isCurrentlyLiked) {
      await _repository.unlikeReply(postId, replyId, userId);
    } else {
      final like = ReplyLikeEntity(
        id: const Uuid().v4(),
        postId: postId,
        commentId: commentId,
        replyId: replyId,
        userId: userId,
        createdAt: DateTime.now(),
      );
      await _repository.likeReply(like);
    }
  }
}
