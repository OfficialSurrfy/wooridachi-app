import 'package:uuid/uuid.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../translation/domain/repositories/translation_repository.dart';
import '../entities/post_reply_entity.dart';
import '../repositories/post_reply_repository.dart';

class AddPostReplyUsecase {
  final AuthRepository _authRepository;
  final PostReplyRepository _postReplyRepository;
  final TranslationRepository _translationRepository;
  final Uuid _uuid;

  AddPostReplyUsecase(
    this._authRepository,
    this._postReplyRepository,
    this._translationRepository,
    this._uuid,
  );

  Future<void> call(String postId, String commentId, String content) async {
    try {
      final userId = _authRepository.getCurrentUserId();
      final replyId = _uuid.v4();

      final translatedContent = await _translationRepository.translateText(content);

      final reply = PostReplyEntity(
        id: replyId,
        postId: postId,
        commentId: commentId,
        userId: userId,
        content: content,
        translatedContent: translatedContent,
        createdAt: DateTime.now(),
      );

      await _postReplyRepository.addPostReply(reply);
    } catch (e) {
      throw Exception(e);
    }
  }
}
