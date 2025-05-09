import '../models/user_report_model.dart';
import '../models/user_block_model.dart';

abstract class BlockReportDatasource {
  // Block User
  Future<List<UserBlockModel>> getBlockedUsers(String blockerUserId);
  Future<void> setUserBlockList(String blockerUserId, List<UserBlockModel> userBlockList);

  // Report User
  Future<void> reportUser(UserReportModel userReportModel);
}
