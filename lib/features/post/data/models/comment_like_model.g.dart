// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentLikeModel _$CommentLikeModelFromJson(Map<String, dynamic> json) =>
    CommentLikeModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentLikeModelToJson(CommentLikeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
