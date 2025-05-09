import '../repositories/post_reply_repository.dart';

class DeletePostReplyUsecase {
  final PostReplyRepository _postReplyRepository;

  DeletePostReplyUsecase(this._postReplyRepository);

  Future<void> call(String postId, String replyId) async {
    try {
      await _postReplyRepository.deletePostReply(postId, replyId);
    } catch (e) {
      rethrow;
    }
  }
}
