import '../../../auth/domain/exceptions/auth_exceptions.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../entities/post_view_dto.dart';
import '../entities/sort_by_options.dart';
import '../repositories/post_like_repository.dart';
import '../repositories/post_repository.dart';

class GetFilteredPostsUsecase {
  final AuthRepository _authRepository;
  final PostRepository _postRepository;
  final UserRepository _userRepository;
  final PostLikeRepository _postLikeRepository;

  GetFilteredPostsUsecase(this._postRepository, this._authRepository, this._userRepository, this._postLikeRepository);

  Future<List<PostViewDto>> call({
    String? searchQuery,
    PostSortByOptions? sortBy,
  }) async {
    try {
      final posts = await _postRepository.getFilteredPosts(
        searchQuery: searchQuery,
        sortBy: sortBy,
      );

      final currentUserId = _authRepository.getCurrentUserId();
      final List<PostViewDto> postViewDtos = [];

      for (var post in posts) {
        bool isLiked = await _postLikeRepository.isLiked(post.id, currentUserId);

        try {
          final user = await _userRepository.getUserById(post.userId);
          postViewDtos.add(PostViewDto(post, user, null, isLiked));
        } on UserNotFoundException {
          continue;
        }
      }

      return postViewDtos;

    } catch (e) {
      rethrow;
    }
  }
}
