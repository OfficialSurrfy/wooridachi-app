import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/post_comment_entity.dart';

part 'post_comment_model.g.dart';

@JsonSerializable()
class PostCommentModel {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final String? translatedContent;
  final DateTime createdAt;
  final int likesCount;

  PostCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.translatedContent,
    required this.createdAt,
    this.likesCount = 0,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) => _$PostCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentModelToJson(this);

  PostCommentEntity toEntity() => PostCommentEntity(
        id: id,
        postId: postId,
        userId: userId,
        content: content,
        translatedContent: translatedContent,
        createdAt: createdAt,
        likesCount: likesCount,
      );
}
