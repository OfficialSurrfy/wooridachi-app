import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/sort_by_options.dart';
import '../../domain/exceptions/post_exceptions.dart';
import '../models/post_model.dart';
import 'post_datasource.dart';

class PostDatasourceImpl implements PostDatasource {
  final FirebaseFirestore _firestore;

  PostDatasourceImpl(this._firestore);

  static const String _collectionName = 'posts';
  static const String _userIdField = 'userId';
  static const String _createdAtField = 'createdAt';
  static const String _likeCountField = 'likesCount';
  static const String _commentsCountField = 'commentsCount';

  @override
  Future<void> setPost(PostModel post) async {
    try {
      await _firestore.collection(_collectionName).doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PostModel> getPostById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return PostModel.fromJson(doc.data()!);
      } else {
        throw PostNotFoundException();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getPostsByUserId(String userId) async {
    try {
      final docs = await _firestore.collection(_collectionName).where(_userIdField, isEqualTo: userId).get();
      return docs.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getPostsByIds(List<String> postIds) async {
    try {
      if (postIds.isEmpty) return [];

      final docs = await _firestore.collection(_collectionName).where(FieldPath.documentId, whereIn: postIds).get();
      return docs.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getRecentPostsWithLimit(int limit) async {
    try {
      final docs = await _firestore.collection(_collectionName).orderBy(_createdAtField, descending: true).limit(limit).get();
      return docs.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> incrementPostLikeCount(String postId) async {
    try {
      await _firestore.collection(_collectionName).doc(postId).update({
        _likeCountField: FieldValue.increment(1)
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> decrementPostLikeCount(String postId) async {
    try {
      await _firestore.collection(_collectionName).doc(postId).update({
        _likeCountField: FieldValue.increment(-1)
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> incrementPostCommentCount(String postId) async {
    try {
      await _firestore.collection(_collectionName).doc(postId).update({
        _commentsCountField: FieldValue.increment(1)
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> decrementPostCommentCount(String postId, [int? decrementBy]) async {
    try {
      await _firestore.collection(_collectionName).doc(postId).update({
        _commentsCountField: FieldValue.increment(-(decrementBy ?? 1))
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getFilteredPosts({
    String? searchQuery,
    PostSortByOptions? sortBy,
  }) async {
    try {
      // 1) start a query
      var query = _firestore.collection(_collectionName)
          .orderBy(
        sortBy == PostSortByOptions.mostLiked
            ? _likeCountField
            : _createdAtField,
        descending: true,
      );

      // 2) fetch
      final snapshot = await query.get();
      var posts = snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();

      // 3) apply your search filter (if any)
      if ((searchQuery ?? '').trim().isNotEmpty) {
        final q = searchQuery!.toLowerCase();
        var byDesc = posts.where((p) => p.description.toLowerCase().contains(q));
        var byTitle = posts.where((p) => p.title.toLowerCase().contains(q)
            && !byDesc.contains(p));
        posts = [...byDesc, ...byTitle];
      }

      return posts;
    } catch (e) {
      throw Exception(e);
    }
  }

}
