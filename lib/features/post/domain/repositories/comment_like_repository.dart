import '../entities/comment_like_entity.dart';

abstract class CommentLikeRepository {
  Future<void> likeComment(CommentLikeEntity like);
  Future<void> unlikeComment(String postId, String commentId, String userId);
  Future<bool> isLiked(String postId, String commentId, String userId);
}
