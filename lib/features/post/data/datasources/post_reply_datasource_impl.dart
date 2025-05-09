import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uridachi/features/post/data/models/post_reply_model.dart';

import 'post_reply_datasource.dart';

class PostReplyDatasourceImpl implements PostReplyDatasource {
  final FirebaseFirestore _firestore;

  PostReplyDatasourceImpl(this._firestore);

  static const _collectionName = 'post_replies';
  static const _commentIdField = 'commentId';
  static const _createdAtField = 'createdAt';
  static const _likesCountField = 'likesCount';
  static const _postIdField = 'postId';

  @override
  Future<void> deleteReply(String replyId) async {
    try {
      await _firestore.collection(_collectionName).doc(replyId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostReplyModel>> getRepliesByCommentId(String commentId) async {
    try {
      final docs = await _firestore.collection(_collectionName).where(_commentIdField, isEqualTo: commentId).orderBy(_createdAtField, descending: false).get();
      return docs.docs.map((doc) => PostReplyModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> setReply(PostReplyModel reply) async {
    try {
      await _firestore.collection(_collectionName).doc(reply.id).set(reply.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteRepliesByPostId(String postId) async {
    try {
      await _firestore.collection(_collectionName).where(_postIdField, isEqualTo: postId).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteRepliesByCommentId(String commentId) async {
    try {
      await _firestore.collection(_collectionName).where(_commentIdField, isEqualTo: commentId).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> incrementReplyLikeCount(String replyId) async {
    try {
      await _firestore.collection(_collectionName).doc(replyId).update({
        _likesCountField: FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> decrementReplyLikeCount(String replyId) async {
    try {
      await _firestore.collection(_collectionName).doc(replyId).update({
        _likesCountField: FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
