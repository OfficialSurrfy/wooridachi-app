import '../entities/post_comment_entity.dart';
import '../repositories/post_comment_repository.dart';

class UpdatePostCommentUsecase {
  final PostCommentRepository _postCommentRepository;

  UpdatePostCommentUsecase(this._postCommentRepository);

  Future<void> call(PostCommentEntity comment) async {
    await _postCommentRepository.setPostComment(comment);
  }
}
