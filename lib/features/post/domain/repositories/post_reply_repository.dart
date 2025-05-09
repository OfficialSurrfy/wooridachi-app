import '../entities/post_reply_entity.dart';

abstract class PostReplyRepository {
  Future<List<PostReplyEntity>> getPostReplies(String postId);
  Future<void> deletePostReply(String postId, String replyId);
  Future<void> addPostReply(PostReplyEntity postReply);
  Future<void> updatePostReply(PostReplyEntity reply);
}
