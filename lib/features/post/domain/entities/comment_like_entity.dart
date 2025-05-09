import '../../data/models/comment_like_model.dart';

class CommentLikeEntity {
  final String id;
  final String postId;
  final String commentId;
  final String userId;
  final DateTime createdAt;

  CommentLikeEntity({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.createdAt,
  });

  CommentLikeModel toModel() => CommentLikeModel(
        id: id,
        postId: postId,
        commentId: commentId,
        userId: userId,
        createdAt: createdAt,
      );
}
