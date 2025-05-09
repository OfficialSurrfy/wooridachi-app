import 'package:uridachi/features/post/domain/entities/post_reply_entity.dart';

import '../../domain/exceptions/post_reply_exceptions.dart';
import '../../domain/repositories/post_reply_repository.dart';
import '../datasources/post_reply_datasource.dart';
import '../datasources/post_datasource.dart';
import '../datasources/reply_like_datasource.dart';
import '../datasources/transaction_datasource.dart';

class PostReplyRepositoryImpl implements PostReplyRepository {
  final PostReplyDatasource _postReplyDatasource;
  final PostDatasource _postDatasource;
  final ReplyLikeDataSource _replyLikeDatasource;
  final TransactionDatasource _transactionDatasource;

  PostReplyRepositoryImpl(
    this._postReplyDatasource,
    this._postDatasource,
    this._replyLikeDatasource,
    this._transactionDatasource,
  );

  @override
  Future<void> addPostReply(PostReplyEntity postReply) async {
    try {
      await _transactionDatasource.run((transaction) async {
        await _postReplyDatasource.setReply(postReply.toModel());
        await _postDatasource.incrementPostCommentCount(postReply.postId);
      });
    } on PostReplyException {
      throw PostReplyAddException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePostReply(String postId, String replyId) async {
    try {
      await _transactionDatasource.run((transaction) async {
        await _postReplyDatasource.deleteReply(replyId);
        await _replyLikeDatasource.deleteLikesByReplyId(replyId);
        await _postDatasource.decrementPostCommentCount(postId);
      });
    } on PostReplyException {
      throw PostReplyDeleteException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostReplyEntity>> getPostReplies(String postId) async {
    try {
      final replies = await _postReplyDatasource.getRepliesByCommentId(postId);
      return replies.map((reply) => reply.toEntity()).toList();
    } on PostReplyException {
      throw PostReplyGetException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePostReply(PostReplyEntity reply) async {
    try {
      await _postReplyDatasource.setReply(reply.toModel());
    } on PostReplyException {
      throw PostReplyUpdateException();
    } catch (e) {
      rethrow;
    }
  }
}
