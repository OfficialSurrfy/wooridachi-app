import 'package:uuid/uuid.dart';

import '../../domain/exceptions/block_report_exceptions.dart';
import '../datasources/block_report_datasource.dart';

import '../../domain/entities/user_block_entity.dart';
import '../../domain/entities/user_report_entity.dart';
import '../../domain/repositories/block_report_repository.dart';

class BlockReportRepositoryImpl extends BlockReportRepository {
  final BlockReportDatasource _blockReportDatasource;

  BlockReportRepositoryImpl(
    this._blockReportDatasource,
  );

  // Block User
  @override
  Future<List<UserBlockEntity>> getBlockedUsers(String userId) async {
    try {
      final blockUsers = await _blockReportDatasource.getBlockedUsers(userId);
      return blockUsers.map((blockUser) => blockUser.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserBlockEntity>> blockUser(String currentUserId, String targetUserId) async {
    try {
      if (currentUserId == targetUserId) {
        throw const CantBlockYourselfException();
      }

      final currentBlocks = await _blockReportDatasource.getBlockedUsers(currentUserId);

      // If the user is already blocked, throw an exception.
      if (currentBlocks.any((block) => block.blockedUserId == targetUserId)) {
        throw const UserAlreadyBlockedException();
      }

      // If the length of the blocks is greater than 1000, throw an exception.
      // The maximum number of blocked users is around 9000.
      if (currentBlocks.length >= 1000) {
        throw const MaxBlockedUsersException();
      }

      final blockUserEntity = UserBlockEntity(
        id: const Uuid().v4(),
        blockerUserId: currentUserId,
        blockedUserId: targetUserId,
        timestamp: DateTime.now(),
      );

      final updatedBlocks = currentBlocks.map((block) => block.toEntity()).toList();
      updatedBlocks.add(blockUserEntity);

      await _blockReportDatasource.setUserBlockList(blockUserEntity.blockerUserId, updatedBlocks.map((block) => block.toModel()).toList());

      return updatedBlocks;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserBlockEntity>> unblockUser(String currentUserId, String targetUserId) async {
    try {
      final currentBlocks = await _blockReportDatasource.getBlockedUsers(currentUserId);
      final updatedBlocks = currentBlocks.where((block) => block.blockedUserId != targetUserId).map((block) => block.toEntity()).toList();

      // If the user is not blocked, throw an exception.
      if (updatedBlocks.isEmpty) {
        throw const UserNotBlockedException();
      }

      await _blockReportDatasource.setUserBlockList(currentUserId, updatedBlocks.map((block) => block.toModel()).toList());

      return updatedBlocks;
    } catch (e) {
      rethrow;
    }
  }

  // Report User
  @override
  Future<void> reportUser(String currentUserId, String targetUserId, String reason) async {
    try {
      if (currentUserId == targetUserId) {
        throw const CantReportYourselfException();
      }

      final report = UserReportEntity(
        id: const Uuid().v4(),
        reporterUserId: currentUserId,
        reportedUserId: targetUserId,
        reason: reason,
        timestamp: DateTime.now(),
      );

      await _blockReportDatasource.reportUser(report.toModel());
    } catch (e) {
      rethrow;
    }
  }
}
