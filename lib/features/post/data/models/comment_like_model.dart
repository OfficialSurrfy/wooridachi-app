import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/comment_like_entity.dart';

part 'comment_like_model.g.dart';

@JsonSerializable()
class CommentLikeModel {
  final String id;
  final String postId;
  final String commentId;
  final String userId;
  final DateTime createdAt;

  CommentLikeModel({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.createdAt,
  });

  factory CommentLikeModel.fromJson(Map<String, dynamic> json) => _$CommentLikeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentLikeModelToJson(this);

  CommentLikeEntity toEntity() => CommentLikeEntity(
        id: id,
        postId: postId,
        commentId: commentId,
        userId: userId,
        createdAt: createdAt,
      );
}
