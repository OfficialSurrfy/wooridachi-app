import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../entities/comment_view_dto.dart';
import '../entities/post_view_dto.dart';
import '../entities/reply_view_dto.dart';
import '../repositories/post_like_repository.dart';
import '../repositories/post_comment_repository.dart';
import '../repositories/post_reply_repository.dart';
import '../repositories/post_repository.dart';
import '../repositories/comment_like_repository.dart';
import '../repositories/reply_like_repository.dart';

class GetPostDetailsUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final PostLikeRepository _postLikeRepository;
  final PostCommentRepository _postCommentRepository;
  final PostReplyRepository _postReplyRepository;
  final CommentLikeRepository _commentLikeRepository;
  final ReplyLikeRepository _replyLikeRepository;

  GetPostDetailsUsecase(
    this._authRepository,
    this._userRepository,
    this._postRepository,
    this._postLikeRepository,
    this._postCommentRepository,
    this._postReplyRepository,
    this._commentLikeRepository,
    this._replyLikeRepository,
  );

  Future<PostViewDto> call(String postId) async {
    if (postId.isEmpty) {
      throw ArgumentError('Post ID cannot be empty');
    }

    try {
      final currentUserId = _authRepository.getCurrentUserId();
      if (currentUserId.isEmpty) {
        throw StateError('User must be authenticated');
      }

      final post = await _postRepository.getPostById(postId);
      final postAuthor = await _userRepository.getUserById(post.userId);

      final isLiked = await _postLikeRepository.isLiked(post.id, currentUserId);

      final comments = await _postCommentRepository.getPostComments(postId);
      final commentsViewDto = <CommentViewDto>[];

      for (final comment in comments) {
        final commentUser = await _userRepository.getUserById(comment.userId);
        final isCommentLiked = await _commentLikeRepository.isLiked(postId, comment.id, currentUserId);

        final commentReplies = await _postReplyRepository.getPostReplies(comment.id);
        final repliesViewDto = <ReplyViewDto>[];

        for (final reply in commentReplies) {
          final replyUser = await _userRepository.getUserById(reply.userId);
          final isReplyLiked = await _replyLikeRepository.isLiked(postId, reply.id, currentUserId);
          repliesViewDto.add(ReplyViewDto(reply, replyUser, isReplyLiked));
        }

        commentsViewDto.add(CommentViewDto(comment, commentUser, repliesViewDto, isCommentLiked));
      }

      return PostViewDto(post, postAuthor, commentsViewDto, isLiked);
    } catch (e) {
      throw Exception('Failed to get post details: ${e.toString()}');
    }
  }
}
