import '../../domain/entities/sort_by_options.dart';
import '../models/post_model.dart';

abstract class PostDatasource {
  Future<void> setPost(PostModel post);
  Future<List<PostModel>> getRecentPostsWithLimit(int limit);
  Future<PostModel> getPostById(String id);
  Future<List<PostModel>> getPostsByUserId(String userId);
  Future<List<PostModel>> getPostsByIds(List<String> postIds);
  Future<void> deletePost(String id);
  Future<void> incrementPostLikeCount(String postId);
  Future<void> decrementPostLikeCount(String postId);
  Future<void> incrementPostCommentCount(String postId);
  Future<void> decrementPostCommentCount(String postId, [int? decrementBy]);
  Future<List<PostModel>> getFilteredPosts({
    String? searchQuery,
    PostSortByOptions? sortBy,
  });
}
