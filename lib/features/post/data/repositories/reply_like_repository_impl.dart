import '../../domain/entities/reply_like_entity.dart';
import '../../domain/exceptions/reply_like_exceptions.dart';
import '../../domain/repositories/reply_like_repository.dart';
import '../datasources/reply_like_datasource.dart';
import '../datasources/post_reply_datasource.dart';
import '../datasources/transaction_datasource.dart';

class ReplyLikeRepositoryImpl implements ReplyLikeRepository {
  final ReplyLikeDataSource _likeDataSource;
  final PostReplyDatasource _replyDatasource;
  final TransactionDatasource _transactionDatasource;

  ReplyLikeRepositoryImpl({
    required ReplyLikeDataSource likeDataSource,
    required PostReplyDatasource replyDatasource,
    required TransactionDatasource transactionDatasource,
  })  : _likeDataSource = likeDataSource,
        _replyDatasource = replyDatasource,
        _transactionDatasource = transactionDatasource;

  @override
  Future<void> likeReply(ReplyLikeEntity like) async {
    try {
      await _transactionDatasource.run((transaction) async {
        final isAlreadyLiked = await _likeDataSource.isLiked(
          like.postId,
          like.replyId,
          like.userId,
        );
        if (isAlreadyLiked) {
          throw ReplyLikeAlreadyExistsException();
        }

        await _likeDataSource.likeReply(like.toModel());
        await _replyDatasource.incrementReplyLikeCount(like.replyId);
      });
    } on ReplyLikeException {
      throw ReplyLikeAddException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unlikeReply(String postId, String replyId, String userId) async {
    try {
      await _transactionDatasource.run((transaction) async {
        final isLiked = await _likeDataSource.isLiked(postId, replyId, userId);
        if (!isLiked) {
          throw ReplyLikeNotFoundException();
        }

        await _likeDataSource.unlikeReply(postId, replyId, userId);
        await _replyDatasource.decrementReplyLikeCount(replyId);
      });
    } on ReplyLikeException {
      throw ReplyLikeDeleteException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLiked(String postId, String replyId, String userId) async {
    try {
      return await _likeDataSource.isLiked(postId, replyId, userId);
    } on ReplyLikeException {
      throw ReplyLikeNotFoundException();
    } catch (e) {
      rethrow;
    }
  }
}
