import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/block_report_provider.dart';

class BlockDialog extends StatelessWidget {
  final String userId;
  final bool? isChat;

  const BlockDialog({super.key, required this.userId, this.isChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 188,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Color(0xFFC9C9C9), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                text: '이 유저를 ',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: '차단',
                    style: TextStyle(color: Color(0xFF4D27C7)),
                  ),
                  TextSpan(text: '하겠습니까?'),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: '차단하면 이 유저의 ',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: '게시물',
                    style: TextStyle(color: Color(0xFF4D27C7)),
                  ),
                  TextSpan(text: '과 '),
                  TextSpan(
                    text: '댓글',
                    style: TextStyle(color: Color(0xFF4D27C7)),
                  ),
                  TextSpan(text: '을 못 봅니다.'),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    await Provider.of<BlockReportProvider>(context, listen: false).blockUser(context, userId, isChat);
                  },
                  child: const Text(
                    '예',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF4D27C7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '아니오',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
