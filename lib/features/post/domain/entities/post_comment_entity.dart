import 'package:json_annotation/json_annotation.dart';

import '../../data/models/post_comment_model.dart';

part 'post_comment_entity.g.dart';

@JsonSerializable()
class PostCommentEntity {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final String? translatedContent;
  final DateTime createdAt;
  final int likesCount;

  PostCommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.translatedContent,
    required this.createdAt,
    this.likesCount = 0,
  });

  PostCommentModel toModel() => PostCommentModel(
        id: id,
        postId: postId,
        userId: userId,
        content: content,
        translatedContent: translatedContent,
        createdAt: createdAt,
        likesCount: likesCount,
      );

  PostCommentEntity copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    String? translatedContent,
    DateTime? createdAt,
    int? likesCount,
  }) {
    return PostCommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      translatedContent: translatedContent ?? this.translatedContent,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}
