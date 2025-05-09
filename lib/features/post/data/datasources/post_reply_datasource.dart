import '../models/post_reply_model.dart';

abstract class PostReplyDatasource {
  Future<List<PostReplyModel>> getRepliesByCommentId(String commentId);
  Future<void> setReply(PostReplyModel reply);
  Future<void> deleteReply(String replyId);
  Future<void> deleteRepliesByPostId(String postId);
  Future<void> deleteRepliesByCommentId(String commentId);
  Future<void> incrementReplyLikeCount(String replyId);
  Future<void> decrementReplyLikeCount(String replyId);
}
