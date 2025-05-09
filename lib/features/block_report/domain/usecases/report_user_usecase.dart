import '../../../auth/domain/repositories/auth_repository.dart';
import '../repositories/block_report_repository.dart';

class ReportUserUsecase {
  final AuthRepository _authRepository;
  final BlockReportRepository _repository;

  ReportUserUsecase(this._authRepository, this._repository);

  Future<void> call(String targetUserId, String reason) async {
    final currentUserId = _authRepository.getCurrentUserId();
    return _repository.reportUser(currentUserId, targetUserId, reason);
  }
}
