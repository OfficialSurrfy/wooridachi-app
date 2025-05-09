import '../entities/post_reply_entity.dart';
import '../repositories/post_reply_repository.dart';

class UpdatePostReplyUsecase {
  final PostReplyRepository _postReplyRepository;

  UpdatePostReplyUsecase(this._postReplyRepository);

  Future<void> call(PostReplyEntity reply) async {
    try {
      await _postReplyRepository.updatePostReply(reply);
    } catch (e) {
      rethrow;
    }
  }
}
