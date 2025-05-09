import '../../../user/domain/entities/user_entity.dart';
import 'post_entity.dart';
import 'comment_view_dto.dart';

class PostViewDto {
  final PostEntity _post;
  final UserEntity _user;
  final List<CommentViewDto>? _comments;
  bool _isLiked;

  PostViewDto(
    this._post,
    this._user,
    this._comments,
    this._isLiked,
  );

  PostEntity get post => _post;
  UserEntity get user => _user;
  List<CommentViewDto>? get comments => _comments;
  bool get isLiked => _isLiked;

  void setIsLiked(bool isLiked) {
    _isLiked = isLiked;
    _post.likesCount = _post.likesCount + (isLiked ? 1 : -1);
  }

  PostViewDto copyWith({
    PostEntity? post,
    UserEntity? user,
    List<CommentViewDto>? comments,
    bool? isLiked,
  }) {
    return PostViewDto(
      post ?? _post,
      user ?? _user,
      comments ?? _comments,
      isLiked ?? _isLiked,
    );
  }
}
