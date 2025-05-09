import '../../data/models/post_reply_model.dart';

class PostReplyEntity {
  final String id;
  final String postId;
  final String commentId;
  final String userId;
  final String content;
  final String? translatedContent;
  final DateTime createdAt;
  final int likesCount;

  PostReplyEntity({
    required this.id,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.content,
    this.translatedContent,
    required this.createdAt,
    this.likesCount = 0,
  });

  PostReplyModel toModel() => PostReplyModel(
        id: id,
        postId: postId,
        commentId: commentId,
        userId: userId,
        content: content,
        translatedContent: translatedContent,
        createdAt: createdAt,
        likesCount: likesCount,
      );

  PostReplyEntity copyWith({
    String? id,
    String? postId,
    String? commentId,
    String? userId,
    String? content,
    String? translatedContent,
    DateTime? createdAt,
    int? likesCount,
  }) {
    return PostReplyEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      translatedContent: translatedContent ?? this.translatedContent,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}
