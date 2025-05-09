import '../models/post_like_model.dart';

abstract class PostLikeDatasource {
  Future<void> setLike(PostLikeModel like);
  Future<void> deleteLikeByPostIdAndUserId(String postId, String userId);
  Future<void> deleteLikesByPostId(String postId);
  Future<bool> isLiked(String postId, String userId);
  Future<List<String>> getLikedPostIds(String userId);
}
