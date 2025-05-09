import '../../data/models/reply_like_model.dart';

class ReplyLikeEntity {
  final String id;
  final String postId;
  final String commentId;
  final String replyId;
  final String userId;
  final DateTime createdAt;

  ReplyLikeEntity({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.replyId,
    required this.userId,
    required this.createdAt,
  });

  ReplyLikeModel toModel() => ReplyLikeModel(
        id: id,
        postId: postId,
        commentId: commentId,
        replyId: replyId,
        userId: userId,
        createdAt: createdAt,
      );
}
