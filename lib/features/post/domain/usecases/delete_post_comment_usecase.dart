import '../repositories/post_comment_repository.dart';

class DeletePostCommentUsecase {
  final PostCommentRepository _postCommentRepository;

  DeletePostCommentUsecase(this._postCommentRepository);

  Future<void> call(String postId, String commentId) async {
    try {
      await _postCommentRepository.deletePostComment(postId, commentId);
    } catch (e) {
      rethrow;
    }
  }
}
