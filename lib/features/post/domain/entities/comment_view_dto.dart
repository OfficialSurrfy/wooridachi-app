import 'package:uridachi/features/post/domain/entities/post_comment_entity.dart';

import '../../../user/domain/entities/user_entity.dart';
import 'reply_view_dto.dart';

class CommentViewDto {
  PostCommentEntity _comment;
  final UserEntity _user;
  final List<ReplyViewDto>? _replies;
  bool _isLiked;

  CommentViewDto(
    this._comment,
    this._user,
    this._replies,
    this._isLiked,
  );

  PostCommentEntity get comment => _comment;
  set comment(PostCommentEntity value) => _comment = value;

  UserEntity get user => _user;
  List<ReplyViewDto>? get replies => _replies;

  bool get isLiked => _isLiked;
  set isLiked(bool value) => _isLiked = value;
}
