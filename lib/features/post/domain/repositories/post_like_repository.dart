import '../entities/post_like_entity.dart';

abstract class PostLikeRepository {
  Future<void> likePost(PostLikeEntity like);
  Future<void> unlikePost(String postId, String userId);
  Future<bool> isLiked(String postId, String userId);
  Future<List<String>> getLikedPostIds(String userId);
}
