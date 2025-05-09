import '../models/post_comment_model.dart';

abstract class PostCommentDatasource {
  Future<List<PostCommentModel>> getCommentsByPostId(String postId);
  Future<void> setComment(PostCommentModel comment);
  Future<void> deleteComment(String commentId);
  Future<void> deleteCommentsByPostId(String postId);
  Future<void> incrementCommentLikeCount(String commentId);
  Future<void> decrementCommentLikeCount(String commentId);
}
