import '../../domain/entities/post_like_entity.dart';
import '../../domain/exceptions/post_like_exceptions.dart';
import '../../domain/repositories/post_like_repository.dart';
import '../datasources/post_like_datasource.dart';
import '../datasources/post_datasource.dart';
import '../datasources/transaction_datasource.dart';

class PostLikeRepositoryImpl implements PostLikeRepository {
  final PostLikeDatasource _postLikeDatasource;
  final PostDatasource _postDatasource;
  final TransactionDatasource _transactionDatasource;

  PostLikeRepositoryImpl(this._postLikeDatasource, this._postDatasource, this._transactionDatasource);

  @override
  Future<bool> isLiked(String postId, String userId) async {
    try {
      return await _postLikeDatasource.isLiked(postId, userId);
    } on PostLikeException {
      throw PostLikeNotFoundException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getLikedPostIds(String userId) async {
    try {
      return await _postLikeDatasource.getLikedPostIds(userId);
    } on PostLikeException {
      throw PostLikeNotFoundException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> likePost(PostLikeEntity like) async {
    try {
      await _transactionDatasource.run((transaction) async {
        final isAlreadyLiked = await _postLikeDatasource.isLiked(like.postId, like.userId);
        if (isAlreadyLiked) {
          throw PostLikeAlreadyExistsException();
        }

        await _postLikeDatasource.setLike(like.toModel());
        await _postDatasource.incrementPostLikeCount(like.postId);
      });
    } on PostLikeException {
      throw PostLikeAddException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _transactionDatasource.run((transaction) async {
        final isLiked = await _postLikeDatasource.isLiked(postId, userId);
        if (!isLiked) {
          throw PostLikeNotFoundException();
        }

        await _postLikeDatasource.deleteLikeByPostIdAndUserId(postId, userId);
        await _postDatasource.decrementPostLikeCount(postId);
      });
    } on PostLikeException {
      throw PostLikeDeleteException();
    } catch (e) {
      rethrow;
    }
  }
}
