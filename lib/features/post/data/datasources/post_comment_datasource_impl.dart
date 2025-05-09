import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uridachi/features/post/data/models/post_comment_model.dart';

import 'post_comment_datasource.dart';

class PostCommentDatasourceImpl implements PostCommentDatasource {
  final FirebaseFirestore _firestore;

  PostCommentDatasourceImpl(this._firestore);

  static const String _collectionName = 'post_comments';
  static const String _postIdField = 'postId';
  static const String _createdAtField = 'createdAt';
  static const String _likesCountField = 'likesCount';

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection(_collectionName).doc(commentId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostCommentModel>> getCommentsByPostId(String postId) async {
    try {
      final docs = await _firestore.collection(_collectionName).where(_postIdField, isEqualTo: postId).orderBy(_createdAtField, descending: false).get();
      return docs.docs.map((doc) => PostCommentModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> setComment(PostCommentModel comment) async {
    try {
      await _firestore.collection(_collectionName).doc(comment.id).set(comment.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteCommentsByPostId(String postId) async {
    try {
      await _firestore.collection(_collectionName).where(_postIdField, isEqualTo: postId).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> incrementCommentLikeCount(String commentId) async {
    try {
      await _firestore.collection(_collectionName).doc(commentId).update({
        _likesCountField: FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> decrementCommentLikeCount(String commentId) async {
    try {
      await _firestore.collection(_collectionName).doc(commentId).update({
        _likesCountField: FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
