// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReplyModel _$PostReplyModelFromJson(Map<String, dynamic> json) =>
    PostReplyModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      translatedContent: json['translatedContent'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PostReplyModelToJson(PostReplyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'userId': instance.userId,
      'content': instance.content,
      'translatedContent': instance.translatedContent,
      'createdAt': instance.createdAt.toIso8601String(),
      'likesCount': instance.likesCount,
    };
