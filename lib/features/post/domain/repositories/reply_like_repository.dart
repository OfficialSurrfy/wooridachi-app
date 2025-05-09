import '../entities/reply_like_entity.dart';

abstract class ReplyLikeRepository {
  Future<void> likeReply(ReplyLikeEntity like);
  Future<void> unlikeReply(String postId, String replyId, String userId);
  Future<bool> isLiked(String postId, String replyId, String userId);
}
