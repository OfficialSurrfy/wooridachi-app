import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uridachi/features/post/data/models/post_like_model.dart';

import 'post_like_datasource.dart';

class PostLikeDatasourceImpl implements PostLikeDatasource {
  final FirebaseFirestore _firestore;

  PostLikeDatasourceImpl(this._firestore);

  static const String _collectionName = 'post_likes';
  static const String _postIdField = 'postId';
  static const String _userIdField = 'userId';

  @override
  Future<void> setLike(PostLikeModel like) async {
    try {
      await _firestore.collection(_collectionName).doc(like.id).set(like.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteLikeByPostIdAndUserId(String postId, String userId) async {
    try {
      await _firestore.collection(_collectionName).where(_postIdField, isEqualTo: postId).where(_userIdField, isEqualTo: userId).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> isLiked(String postId, String userId) async {
    try {
      final doc = await _firestore.collection(_collectionName).where(_postIdField, isEqualTo: postId).where(_userIdField, isEqualTo: userId).get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<String>> getLikedPostIds(String userId) async {
    try {
      final docs = await _firestore.collection(_collectionName).where(_userIdField, isEqualTo: userId).get();
      return docs.docs.map((doc) => doc.data()[_postIdField] as String).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteLikesByPostId(String postId) async {
    try {
      await _firestore.collection(_collectionName).where(_postIdField, isEqualTo: postId).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
    } catch (e) {
      throw Exception(e);
    }
  }
}
