import 'package:flutter/material.dart';
import '../block_report/presentation/widgets/block_dialog.dart';
import '../block_report/presentation/widgets/report_dialog.dart';

class UserMenuUtils {
  static const String blockIcon = 'assets/images/slash.png';
  static const String reportIcon = 'assets/images/volume-1.png';

  static void showUserMenu(BuildContext context, Offset position, String uploaderId) {
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      color: Colors.white,
      items: [
        PopupMenuItem(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(blockIcon, width: 20, height: 20),
              const SizedBox(width: 8),
              const Text(
                '유저 차단하기',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () => showBlockDialog(context, uploaderId, false));
          },
        ),
        PopupMenuItem(
          height: 2,
          enabled: false,
          child: Container(
            height: 2,
            color: Color(0xFFC9C9C9),
          ),
        ),
        PopupMenuItem(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(reportIcon, width: 20, height: 20),
              const SizedBox(width: 8),
              const Text(
                '유저 신고하기',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () => showReportDialog(context, uploaderId));
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static void showBlockDialog(BuildContext context, String uploaderId, bool? isChat) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlockDialog(userId: uploaderId, isChat: isChat);
      },
    );
  }

  static void showReportDialog(BuildContext context, String uploaderId) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return ReportDialog(userId: uploaderId);
      },
    );
  }
}
