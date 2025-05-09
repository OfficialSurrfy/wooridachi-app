import 'package:flutter/material.dart';

import '../../domain/entities/user_block_entity.dart';
import '../../domain/exceptions/block_report_exceptions.dart';
import '../../domain/usecases/block_user_usecase.dart';
import '../../domain/usecases/get_user_blocks_usecase.dart';
import '../../domain/usecases/report_user_usecase.dart';
import '../widgets/custom_snack_bar.dart';

class BlockReportProvider extends ChangeNotifier {
  final GetUserBlocksUsecase _getUserBlocksUsecase;
  final BlockUserUsecase _blockUserUsecase;
  final ReportUserUsecase _reportUserUsecase;

  BlockReportProvider(this._getUserBlocksUsecase, this._blockUserUsecase, this._reportUserUsecase);

  final List<UserBlockEntity> _blockedUsers = [];

  List<UserBlockEntity> get blockedUsers => _blockedUsers;

  // Presentation Handling
  bool isBlocked(String userId) {
    return _blockedUsers.any((blockUser) => blockUser.blockedUserId == userId);
  }

  // Block User
  Future<void> fetchBlockedUsers(BuildContext context) async {
    try {
      _blockedUsers.clear();
      _blockedUsers.addAll(await _getUserBlocksUsecase.call());
      notifyListeners();
    } on BlockReportException catch (e) {
      if (!context.mounted) return;
      if (e is UserNotFoundException) {
        CustomSnackBar.show(context, '사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> blockUser(BuildContext context, String targetUserId, bool? isChat) async {
    try {
      final updatedBlockedUsers = await _blockUserUsecase.call(targetUserId);

      _blockedUsers.clear();
      _blockedUsers.addAll(updatedBlockedUsers);
      notifyListeners();

      if (!context.mounted) return;

      // If successful, pop the dialog and show a snackbar.
      Navigator.of(context).pop();

      // If the user is blocked in chat, pop the chat view page.
      if (isChat == true) {
        Navigator.of(context).pop();
      }

      CustomSnackBar.show(context, '사용자를 차단했습니다.');
    } on BlockReportException catch (e) {
      if (!context.mounted) return;

      if (e is UserAlreadyBlockedException) {
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '이미 차단한 사용자입니다.');
      } else if (e is MaxBlockedUsersException) {
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '최대 차단 사용자 수에 도달했습니다.');
      } else if (e is UserNotFoundException) {
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '사용자를 찾을 수 없습니다.');
      } else if (e is CantBlockYourselfException) {
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '자신을 차단할 수 없습니다.');
      }
    } catch (e) {
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // Report User
  Future<void> reportUser(BuildContext context, String targetUserId, String reason) async {
    try {
      await _reportUserUsecase.call(targetUserId, reason);

      // If successful, pop the dialog and show a snackbar.
      if (!context.mounted) return;
      Navigator.of(context).pop();
      CustomSnackBar.show(context, '사용자를 신고했습니다.');
    } on Exception catch (e) {
      if (!context.mounted) return;

      if (e is UserNotFoundException) {
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '사용자를 찾을 수 없습니다.');
      } else if (e is CantReportYourselfException) {
        Navigator.of(context).pop();
        CustomSnackBar.show(context, '자신을 신고할 수 없습니다.');
      }
    } catch (e) {
      CustomSnackBar.show(context, '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }
}
