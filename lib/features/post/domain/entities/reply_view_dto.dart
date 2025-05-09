import '../../../user/domain/entities/user_entity.dart';
import 'post_reply_entity.dart';

class ReplyViewDto {
  PostReplyEntity _reply;
  final UserEntity _user;
  bool _isLiked;

  ReplyViewDto(this._reply, this._user, this._isLiked);

  PostReplyEntity get reply => _reply;
  set reply(PostReplyEntity value) => _reply = value;

  UserEntity get user => _user;

  bool get isLiked => _isLiked;
  set isLiked(bool value) => _isLiked = value;
}
