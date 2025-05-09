// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_like_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyLikeModel _$ReplyLikeModelFromJson(Map<String, dynamic> json) =>
    ReplyLikeModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      commentId: json['commentId'] as String,
      replyId: json['replyId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReplyLikeModelToJson(ReplyLikeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'replyId': instance.replyId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
