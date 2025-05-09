import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment_like_model.dart';
import 'comment_like_datasource.dart';

class CommentLikeDataSourceImpl implements CommentLikeDataSource {
  static const String commentLikesCollection = 'comment_likes';
  static const String userIdField = 'userId';
  static const String postIdField = 'postId';
  static const String commentIdField = 'commentId';

  final FirebaseFirestore _firestore;

  CommentLikeDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> likeComment(CommentLikeModel like) async {
    await _firestore.collection(commentLikesCollection).doc(like.id).set(like.toJson());
  }

  @override
  Future<void> unlikeComment(String postId, String commentId, String userId) async {
    final querySnapshot = await _firestore.collection(commentLikesCollection).where(postIdField, isEqualTo: postId).where(commentIdField, isEqualTo: commentId).where(userIdField, isEqualTo: userId).get();

    if (querySnapshot.docs.isNotEmpty) {
      await _firestore.collection(commentLikesCollection).doc(querySnapshot.docs.first.id).delete();
    }
  }

  @override
  Future<bool> isLiked(String postId, String commentId, String userId) async {
    final querySnapshot = await _firestore.collection(commentLikesCollection).where(postIdField, isEqualTo: postId).where(commentIdField, isEqualTo: commentId).where(userIdField, isEqualTo: userId).get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<void> deleteLikesByPostId(String postId) async {
    final likesSnapshot = await _firestore.collection(commentLikesCollection).where(postIdField, isEqualTo: postId).get();

    for (final likeDoc in likesSnapshot.docs) {
      await likeDoc.reference.delete();
    }
  }

  @override
  Future<void> deleteLikesByCommentId(String commentId) async {
    final likesSnapshot = await _firestore.collection(commentLikesCollection).where(commentIdField, isEqualTo: commentId).get();

    for (final likeDoc in likesSnapshot.docs) {
      await likeDoc.reference.delete();
    }
  }
}
