import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../entities/post_view_dto.dart';
import '../repositories/post_like_repository.dart';
import '../repositories/post_repository.dart';

class GetUserLikedPostsUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final PostLikeRepository _postLikeRepository;

  GetUserLikedPostsUsecase(
    this._authRepository,
    this._userRepository,
    this._postRepository,
    this._postLikeRepository,
  );

  Future<List<PostViewDto>> call() async {
    try {
      final currentUserId = _authRepository.getCurrentUserId();
      final likedPostIds = await _postLikeRepository.getLikedPostIds(currentUserId);
      final posts = await _postRepository.getPostsByIds(likedPostIds);
      List<PostViewDto> postsWithLikeStatus = [];

      for (final post in posts) {
        try {
          final postAuthor = await _userRepository.getUserById(post.userId);
          postsWithLikeStatus.add(PostViewDto(post, postAuthor, null, true)); // isLiked is always true for liked posts
        } catch (userError) {
          continue;
        }
      }

      return postsWithLikeStatus;
    } catch (e) {
      rethrow;
    }
  }
}
