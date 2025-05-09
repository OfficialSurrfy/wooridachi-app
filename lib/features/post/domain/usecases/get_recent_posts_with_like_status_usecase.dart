import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../entities/post_view_dto.dart';
import '../repositories/post_like_repository.dart';
import '../repositories/post_repository.dart';

class GetRecentPostsWithLikeStatusUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final PostLikeRepository _postLikeRepository;

  GetRecentPostsWithLikeStatusUsecase(
    this._authRepository,
    this._userRepository,
    this._postRepository,
    this._postLikeRepository,
  );

  Future<List<PostViewDto>> call({int? limit = 5}) async {
    try {
      final posts = await _postRepository.getRecentPosts(limit);
      final currentUserId = _authRepository.getCurrentUserId();
      List<PostViewDto> postsWithLikeStatus = [];

      for (final post in posts) {
        try {
          final isLiked = await _postLikeRepository.isLiked(post.id, currentUserId);
          try {
            final postAuthor = await _userRepository.getUserById(post.userId);
            postsWithLikeStatus.add(PostViewDto(post, postAuthor, null, isLiked));
          } catch (userError) {
            continue;
          }
        } catch (e) {
          continue;
        }
      }

      return postsWithLikeStatus;
    } catch (e) {
      rethrow;
    }
  }
}
