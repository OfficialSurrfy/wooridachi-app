import '../../../user/domain/repositories/user_repository.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/comment_view_dto.dart';
import '../entities/reply_view_dto.dart';
import '../repositories/post_comment_repository.dart';
import '../repositories/post_reply_repository.dart';
import '../repositories/comment_like_repository.dart';
import '../repositories/reply_like_repository.dart';

class GetPostCommentsUsecase {
  final PostCommentRepository _postCommentRepository;
  final UserRepository _userRepository;
  final PostReplyRepository _postReplyRepository;
  final CommentLikeRepository _commentLikeRepository;
  final ReplyLikeRepository _replyLikeRepository;
  final AuthRepository _authRepository;

  GetPostCommentsUsecase(
    this._postCommentRepository,
    this._userRepository,
    this._postReplyRepository,
    this._commentLikeRepository,
    this._replyLikeRepository,
    this._authRepository,
  );

  Future<List<CommentViewDto>> call(String postId) async {
    try {
      final comments = await _postCommentRepository.getPostComments(postId);
      final currentUserId = _authRepository.getCurrentUserId();

      List<CommentViewDto> commentsWithUser = [];

      for (final comment in comments) {
        final user = await _userRepository.getUserById(comment.userId);
        final isCommentLiked = await _commentLikeRepository.isLiked(postId, comment.id, currentUserId);

        final replies = await _postReplyRepository.getPostReplies(comment.id);

        List<ReplyViewDto> repliesWithUser = [];
        for (final reply in replies) {
          final replyUser = await _userRepository.getUserById(reply.userId);
          final isReplyLiked = await _replyLikeRepository.isLiked(postId, reply.id, currentUserId);
          repliesWithUser.add(ReplyViewDto(reply, replyUser, isReplyLiked));
        }

        commentsWithUser.add(CommentViewDto(comment, user, repliesWithUser, isCommentLiked));
      }

      return commentsWithUser;
    } catch (e) {
      rethrow;
    }
  }
}
