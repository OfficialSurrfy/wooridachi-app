import 'package:uuid/uuid.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../translation/domain/repositories/translation_repository.dart';
import '../entities/post_comment_entity.dart';
import '../repositories/post_comment_repository.dart';

class AddPostCommentUsecase {
  final AuthRepository _authRepository;
  final PostCommentRepository _postCommentRepository;
  final TranslationRepository _translationRepository;
  final Uuid _uuid;

  AddPostCommentUsecase(
    this._authRepository,
    this._postCommentRepository,
    this._translationRepository,
    this._uuid,
  );

  Future<void> call(String postId, String content) async {
    try {
      final userId = _authRepository.getCurrentUserId();
      final commentId = _uuid.v4();

      final translatedContent = await _translationRepository.translateText(content);

      final comment = PostCommentEntity(
        id: commentId,
        postId: postId,
        userId: userId,
        content: content,
        translatedContent: translatedContent,
        createdAt: DateTime.now(),
      );

      await _postCommentRepository.setPostComment(comment);
    } catch (e) {
      throw Exception(e);
    }
  }
}
