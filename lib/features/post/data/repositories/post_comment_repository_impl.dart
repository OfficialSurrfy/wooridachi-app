import 'package:uridachi/features/post/domain/entities/post_comment_entity.dart';

import '../../domain/exceptions/post_comment_exceptions.dart';
import '../../domain/repositories/post_comment_repository.dart';
import '../datasources/comment_like_datasource.dart';
import '../datasources/post_comment_datasource.dart';
import '../datasources/post_datasource.dart';
import '../datasources/post_reply_datasource.dart';
import '../datasources/reply_like_datasource.dart';
import '../datasources/transaction_datasource.dart';

class PostCommentRepositoryImpl implements PostCommentRepository {
  final PostCommentDatasource _postCommentDatasource;
  final PostDatasource _postDatasource;
  final PostReplyDatasource _postReplyDatasource;
  final CommentLikeDataSource _commentLikeDatasource;
  final ReplyLikeDataSource _replyLikeDatasource;
  final TransactionDatasource _transactionDatasource;

  PostCommentRepositoryImpl(
    this._postCommentDatasource,
    this._postDatasource,
    this._postReplyDatasource,
    this._commentLikeDatasource,
    this._replyLikeDatasource,
    this._transactionDatasource,
  );

  @override
  Future<void> deletePostComment(String postId, String commentId) async {
    try {
      await _transactionDatasource.run((transaction) async {
        await _postCommentDatasource.deleteComment(commentId);

        await _commentLikeDatasource.deleteLikesByCommentId(commentId);

        final repliesCount = await _replyLikeDatasource.getRepliesCountByCommentId(commentId);

        await _postReplyDatasource.deleteRepliesByCommentId(commentId);
        await _replyLikeDatasource.deleteLikesByCommentId(commentId);

        await _postDatasource.decrementPostCommentCount(postId, repliesCount + 1);
      });
    } on PostCommentException {
      throw PostCommentDeleteException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostCommentEntity>> getPostComments(String postId) async {
    try {
      final comments = await _postCommentDatasource.getCommentsByPostId(postId);
      return comments.map((comment) => comment.toEntity()).toList();
    } on PostCommentException {
      throw PostCommentGetException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setPostComment(PostCommentEntity comment) async {
    try {
      await _transactionDatasource.run((transaction) async {
        await _postCommentDatasource.setComment(comment.toModel());
        await _postDatasource.incrementPostCommentCount(comment.postId);
      });
    } on PostCommentException {
      throw PostCommentAddException();
    } catch (e) {
      rethrow;
    }
  }
}
