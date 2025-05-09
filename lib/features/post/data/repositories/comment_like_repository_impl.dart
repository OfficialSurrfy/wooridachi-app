import '../../domain/entities/comment_like_entity.dart';
import '../../domain/exceptions/comment_like_exceptions.dart';
import '../../domain/repositories/comment_like_repository.dart';
import '../datasources/comment_like_datasource.dart';
import '../datasources/post_comment_datasource.dart';
import '../datasources/transaction_datasource.dart';

class CommentLikeRepositoryImpl implements CommentLikeRepository {
  final CommentLikeDataSource _likeDataSource;
  final PostCommentDatasource _commentDatasource;
  final TransactionDatasource _transactionDatasource;

  CommentLikeRepositoryImpl({
    required CommentLikeDataSource likeDataSource,
    required PostCommentDatasource commentDatasource,
    required TransactionDatasource transactionDatasource,
  })  : _likeDataSource = likeDataSource,
        _commentDatasource = commentDatasource,
        _transactionDatasource = transactionDatasource;

  @override
  Future<void> likeComment(CommentLikeEntity like) async {
    try {
      await _transactionDatasource.run((transaction) async {
        final isAlreadyLiked = await _likeDataSource.isLiked(
          like.postId,
          like.commentId,
          like.userId,
        );
        if (isAlreadyLiked) {
          throw CommentLikeAlreadyExistsException();
        }

        await _likeDataSource.likeComment(like.toModel());
        await _commentDatasource.incrementCommentLikeCount(like.commentId);
      });
    } on CommentLikeException {
      throw CommentLikeAddException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unlikeComment(String postId, String commentId, String userId) async {
    try {
      await _transactionDatasource.run((transaction) async {
        final isLiked = await _likeDataSource.isLiked(postId, commentId, userId);
        if (!isLiked) {
          throw CommentLikeNotFoundException();
        }

        await _likeDataSource.unlikeComment(postId, commentId, userId);
        await _commentDatasource.decrementCommentLikeCount(commentId);
      });
    } on CommentLikeException {
      throw CommentLikeDeleteException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLiked(String postId, String commentId, String userId) async {
    try {
      return await _likeDataSource.isLiked(postId, commentId, userId);
    } on CommentLikeException {
      throw CommentLikeNotFoundException();
    } catch (e) {
      rethrow;
    }
  }
}
