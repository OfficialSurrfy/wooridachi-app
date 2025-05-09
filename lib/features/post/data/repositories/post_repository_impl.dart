import 'package:uridachi/features/post/domain/entities/post_entity.dart';

import '../../domain/entities/sort_by_options.dart';
import '../../domain/exceptions/post_exceptions.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/comment_like_datasource.dart';
import '../datasources/post_datasource.dart';
import '../datasources/post_comment_datasource.dart';
import '../datasources/post_like_datasource.dart';
import '../datasources/post_reply_datasource.dart';
import '../datasources/reply_like_datasource.dart';
import '../datasources/transaction_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDatasource _postDatasource;
  final PostCommentDatasource _postCommentDatasource;
  final PostLikeDatasource _postLikeDatasource;
  final PostReplyDatasource _postReplyDatasource;
  final CommentLikeDataSource _commentLikeDatasource;
  final ReplyLikeDataSource _replyLikeDatasource;
  final TransactionDatasource _transactionDatasource;

  PostRepositoryImpl(
    this._postDatasource,
    this._postCommentDatasource,
    this._postLikeDatasource,
    this._postReplyDatasource,
    this._commentLikeDatasource,
    this._replyLikeDatasource,
    this._transactionDatasource,
  );

  @override
  Future<PostEntity> getPostById(String id) async {
    try {
      final post = await _postDatasource.getPostById(id);
      return post.toEntity();
    } on PostException {
      throw PostNotFoundException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostEntity>> getPostsByUserId(String userId) async {
    try {
      final posts = await _postDatasource.getPostsByUserId(userId);
      return posts.map((post) => post.toEntity()).toList();
    } on PostException {
      throw PostGetException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostEntity>> getPostsByIds(List<String> postIds) async {
    try {
      final posts = await _postDatasource.getPostsByIds(postIds);
      return posts.map((post) => post.toEntity()).toList();
    } on PostException {
      throw PostGetException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setPost(PostEntity post) async {
    try {
      await _postDatasource.setPost(post.toModel());
    } on PostException {
      throw PostAddException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    try {
      await _postDatasource.setPost(post.toModel());
    } on PostException {
      throw PostUpdateException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      await _transactionDatasource.run((transaction) async {
        await _postDatasource.deletePost(id);

        await _postCommentDatasource.deleteCommentsByPostId(id);
        await _commentLikeDatasource.deleteLikesByPostId(id);

        await _postReplyDatasource.deleteRepliesByPostId(id);
        await _replyLikeDatasource.deleteLikesByPostId(id);

        await _postLikeDatasource.deleteLikesByPostId(id);
      });
    } on PostException {
      throw PostDeleteException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostEntity>> getRecentPosts(int? limit) async {
    try {
      final posts = await _postDatasource.getRecentPostsWithLimit(limit ?? 10);
      return posts.map((post) => post.toEntity()).toList();
    } on PostException {
      throw PostGetException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> incrementPostLikeCount(String postId) async {
    try {
      await _postDatasource.incrementPostLikeCount(postId);
    } on PostException {
      throw PostIncrementLikeCountException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> decrementPostLikeCount(String postId) async {
    try {
      await _postDatasource.decrementPostLikeCount(postId);
    } on PostException {
      throw PostDecrementLikeCountException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> incrementPostCommentCount(String postId) async {
    try {
      await _postDatasource.incrementPostCommentCount(postId);
    } on PostException {
      throw PostIncrementCommentCountException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> decrementPostCommentCount(String postId) async {
    try {
      await _postDatasource.decrementPostCommentCount(postId);
    } on PostException {
      throw PostDecrementCommentCountException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostEntity>> getFilteredPosts({
    String? searchQuery,
    PostSortByOptions? sortBy,
  }) async {
    try {
      final posts = await _postDatasource.getFilteredPosts(
        searchQuery: searchQuery,
        sortBy: sortBy,
      );
      return posts.map((post) => post.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
