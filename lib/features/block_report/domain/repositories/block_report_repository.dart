import '../entities/user_block_entity.dart';

abstract class BlockReportRepository {
  // Block User
  Future<List<UserBlockEntity>> getBlockedUsers(String currentUserId);
  Future<List<UserBlockEntity>> blockUser(String currentUserId, String targetUserId);
  Future<List<UserBlockEntity>> unblockUser(String currentUserId, String targetUserId);

  // Report User
  Future<void> reportUser(String currentUserId, String targetUserId, String reason);
}
