import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/post_like_entity.dart';

part 'post_like_model.g.dart';

@JsonSerializable()
class PostLikeModel {
  final String id;
  final String postId;
  final String userId;
  final DateTime createdAt;

  PostLikeModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  factory PostLikeModel.fromJson(Map<String, dynamic> json) => _$PostLikeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostLikeModelToJson(this);

  PostLikeEntity toEntity() => PostLikeEntity(
        id: id,
        postId: postId,
        userId: userId,
        createdAt: createdAt,
      );
}
