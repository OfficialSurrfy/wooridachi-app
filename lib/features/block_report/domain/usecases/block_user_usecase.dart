import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/user_block_entity.dart';
import '../repositories/block_report_repository.dart';

class BlockUserUsecase {
  final AuthRepository _authRepository;
  final BlockReportRepository _repository;

  BlockUserUsecase(this._authRepository, this._repository);

  Future<List<UserBlockEntity>> call(String targetUserId) async {
    final currentUserId = _authRepository.getCurrentUserId();
    return _repository.blockUser(currentUserId, targetUserId);
  }
}
