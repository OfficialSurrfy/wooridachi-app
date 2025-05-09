import 'package:uuid/uuid.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../../../image/domain/repositories/image_repository.dart';
import '../../../translation/domain/repositories/translation_repository.dart';
import '../entities/post_entity.dart';
import '../entities/post_upload_dto.dart';
import '../repositories/post_repository.dart';
import '../entities/post_view_dto.dart';

class UploadPostUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final ImageRepository _imageRepository;
  final TranslationRepository _translationRepository;
  final Uuid _uuid;

  UploadPostUsecase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required PostRepository postRepository,
    required ImageRepository imageRepository,
    required TranslationRepository translationRepository,
    required Uuid uuid,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _postRepository = postRepository,
        _imageRepository = imageRepository,
        _translationRepository = translationRepository,
        _uuid = uuid;

  Future<PostViewDto> call(PostUploadDto dto) async {
    try {
      final postId = _uuid.v4();
      final userId = _authRepository.getCurrentUserId();
      final user = await _userRepository.getUserById(userId);

      List<String>? imageUrls = [];

      if (dto.images != null) {
        for (int i = 0; i < dto.images!.length; i++) {
          final image = dto.images![i];
          final imagePath = 'posts/$postId/$i';
          final imageUrl = await _imageRepository.uploadImage(image, imagePath);
          imageUrls.add(imageUrl);
        }
      }

      final translatedTitle = await _translationRepository.translateText(dto.title);
      final translatedDescription = await _translationRepository.translateText(dto.description);

      final post = PostEntity(
        id: postId,
        userId: userId,
        title: dto.title,
        description: dto.description,
        translatedTitle: translatedTitle,
        translatedDescription: translatedDescription,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        likesCount: 0,
        commentsCount: 0,
        address: dto.address,
        selectedPlace: dto.selectedPlace,
        rating: dto.rating,
        moneyRating: dto.moneyRating,
      );

      await _postRepository.setPost(post);

      return PostViewDto(post, user, null, false);
    } catch (e) {
      rethrow;
    }
  }
}
