import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reply_like_entity.dart';

part 'reply_like_model.g.dart';

@JsonSerializable()
class ReplyLikeModel {
  final String id;
  final String postId;
  final String commentId;
  final String replyId;
  final String userId;
  final DateTime createdAt;

  ReplyLikeModel({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.replyId,
    required this.userId,
    required this.createdAt,
  });

  factory ReplyLikeModel.fromJson(Map<String, dynamic> json) => _$ReplyLikeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyLikeModelToJson(this);

  ReplyLikeEntity toEntity() => ReplyLikeEntity(
        id: id,
        postId: postId,
        commentId: commentId,
        replyId: replyId,
        userId: userId,
        createdAt: createdAt,
      );
}
