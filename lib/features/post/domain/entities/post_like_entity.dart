import '../../data/models/post_like_model.dart';

class PostLikeEntity {
  final String id;
  final String postId;
  final String userId;
  final DateTime createdAt;

  PostLikeEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  PostLikeModel toModel() => PostLikeModel(
        id: id,
        postId: postId,
        userId: userId,
        createdAt: createdAt,
      );
}
