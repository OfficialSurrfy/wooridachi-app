import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reply_like_model.dart';

abstract class ReplyLikeDataSource {
  Future<void> likeReply(ReplyLikeModel like);
  Future<void> unlikeReply(String postId, String replyId, String userId);
  Future<bool> isLiked(String postId, String replyId, String userId);
  Future<void> deleteLikesByPostId(String postId);
  Future<void> deleteLikesByCommentId(String commentId);
  Future<void> deleteLikesByReplyId(String replyId);
  Future<int> getRepliesCountByCommentId(String commentId);
}

class ReplyLikeDataSourceImpl implements ReplyLikeDataSource {
  static const String replyLikesCollection = 'reply_likes';
  static const String userIdField = 'userId';
  static const String postIdField = 'postId';
  static const String replyIdField = 'replyId';
  static const String commentIdField = 'commentId';

  final FirebaseFirestore _firestore;

  ReplyLikeDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> likeReply(ReplyLikeModel like) async {
    await _firestore.collection(replyLikesCollection).doc(like.id).set(like.toJson());
  }

  @override
  Future<void> unlikeReply(String postId, String replyId, String userId) async {
    final querySnapshot = await _firestore.collection(replyLikesCollection).where(postIdField, isEqualTo: postId).where(replyIdField, isEqualTo: replyId).where(userIdField, isEqualTo: userId).get();

    if (querySnapshot.docs.isNotEmpty) {
      await _firestore.collection(replyLikesCollection).doc(querySnapshot.docs.first.id).delete();
    }
  }

  @override
  Future<bool> isLiked(String postId, String replyId, String userId) async {
    final querySnapshot = await _firestore.collection(replyLikesCollection).where(postIdField, isEqualTo: postId).where(replyIdField, isEqualTo: replyId).where(userIdField, isEqualTo: userId).get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<void> deleteLikesByPostId(String postId) async {
    final likesSnapshot = await _firestore.collection(replyLikesCollection).where(postIdField, isEqualTo: postId).get();

    for (final likeDoc in likesSnapshot.docs) {
      await likeDoc.reference.delete();
    }
  }

  @override
  Future<void> deleteLikesByCommentId(String commentId) async {
    final likesSnapshot = await _firestore.collection(replyLikesCollection).where(commentIdField, isEqualTo: commentId).get();

    for (final likeDoc in likesSnapshot.docs) {
      await likeDoc.reference.delete();
    }
  }

  @override
  Future<void> deleteLikesByReplyId(String replyId) async {
    final likesSnapshot = await _firestore.collection(replyLikesCollection).where(replyIdField, isEqualTo: replyId).get();

    for (final likeDoc in likesSnapshot.docs) {
      await likeDoc.reference.delete();
    }
  }

  @override
  Future<int> getRepliesCountByCommentId(String commentId) async {
    final likesSnapshot = await _firestore.collection(replyLikesCollection).where(commentIdField, isEqualTo: commentId).get();
    return likesSnapshot.docs.length;
  }
}
