import '../entities/post_entity.dart';
import '../entities/sort_by_options.dart';

abstract class PostRepository {
  Future<void> setPost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(String id);
  Future<PostEntity> getPostById(String id);
  Future<List<PostEntity>> getPostsByUserId(String userId);
  Future<List<PostEntity>> getPostsByIds(List<String> postIds);
  Future<List<PostEntity>> getRecentPosts(int? limit);
  Future<void> incrementPostLikeCount(String postId);
  Future<void> decrementPostLikeCount(String postId);
  Future<void> incrementPostCommentCount(String postId);
  Future<void> decrementPostCommentCount(String postId);
  Future<List<PostEntity>> getFilteredPosts({
    String? searchQuery,
    PostSortByOptions? sortBy,
  });
}
