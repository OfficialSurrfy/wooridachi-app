import '../entities/post_comment_entity.dart';

abstract class PostCommentRepository {
  Future<void> setPostComment(PostCommentEntity comment);
  Future<List<PostCommentEntity>> getPostComments(String postId);
  Future<void> deletePostComment(String postId, String commentId);
}
