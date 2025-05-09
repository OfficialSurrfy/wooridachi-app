import '../../../user/domain/repositories/user_repository.dart';
import '../repositories/post_like_repository.dart';
import '../repositories/post_repository.dart';
import '../entities/post_view_dto.dart';

class GetPostWithLikeStatusUsecase {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final PostLikeRepository _postLikeRepository;

  GetPostWithLikeStatusUsecase(
    this._userRepository,
    this._postRepository,
    this._postLikeRepository,
  );

  Future<PostViewDto> execute(String postId, String userId) async {
    final post = await _postRepository.getPostById(postId);
    final user = await _userRepository.getUserById(userId);
    final isLiked = await _postLikeRepository.isLiked(postId, userId);

    return PostViewDto(post, user, null, isLiked);
  }
}
