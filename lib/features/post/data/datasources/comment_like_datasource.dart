import '../models/comment_like_model.dart';

abstract class CommentLikeDataSource {
  Future<void> likeComment(CommentLikeModel like);
  Future<void> unlikeComment(String postId, String commentId, String userId);
  Future<bool> isLiked(String postId, String commentId, String userId);
  Future<void> deleteLikesByPostId(String postId);
  Future<void> deleteLikesByCommentId(String commentId);
}
