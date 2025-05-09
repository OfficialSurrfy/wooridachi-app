import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/post_model.dart';
import '../providers/block_report_provider.dart';

class ReportDialog extends StatelessWidget {
  final String userId;

  const ReportDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    TextEditingController reportController = TextEditingController();

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          height: 310,
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
              const Text(
                '신고하는 이유를 작성 해 주십시오',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: reportController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '텍스트 입력',
                  hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC9C9C9), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC9C9C9), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC9C9C9), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  counterText: '',
                ),
                maxLines: 5,
                maxLength: 1000,
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () async {
                  await Provider.of<BlockReportProvider>(context, listen: false).reportUser(context, userId, reportController.text);
                },
                child: Container(
                  width: 177,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D27C7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Text(
                      '신고하기',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
