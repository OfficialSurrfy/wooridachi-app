import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/post_reply_entity.dart';

part 'post_reply_model.g.dart';

@JsonSerializable()
class PostReplyModel {
  final String id;
  final String postId;
  final String commentId;
  final String userId;
  final String content;
  final String? translatedContent;
  final DateTime createdAt;
  final int likesCount;

  PostReplyModel({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.content,
    this.translatedContent,
    required this.createdAt,
    this.likesCount = 0,
  });

  factory PostReplyModel.fromJson(Map<String, dynamic> json) => _$PostReplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostReplyModelToJson(this);

  PostReplyEntity toEntity() => PostReplyEntity(
        id: id,
        postId: postId,
        commentId: commentId,
        userId: userId,
        content: content,
        translatedContent: translatedContent,
        createdAt: createdAt,
        likesCount: likesCount,
      );
}
