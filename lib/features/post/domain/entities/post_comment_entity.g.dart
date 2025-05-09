// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentEntity _$PostCommentEntityFromJson(Map<String, dynamic> json) =>
    PostCommentEntity(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      translatedContent: json['translatedContent'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PostCommentEntityToJson(PostCommentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'content': instance.content,
      'translatedContent': instance.translatedContent,
      'createdAt': instance.createdAt.toIso8601String(),
      'likesCount': instance.likesCount,
    };
