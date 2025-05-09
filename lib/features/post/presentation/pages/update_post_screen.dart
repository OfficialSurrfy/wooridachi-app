import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/entities/post_view_dto.dart';
import '../providers/post_provider.dart';
import '../../../block_report/presentation/widgets/custom_snack_bar.dart';

class UpdatePostScreen extends StatefulWidget {
  final PostViewDto postViewDto;

  const UpdatePostScreen({
    super.key,
    required this.postViewDto,
  });

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.postViewDto.post.title);
    _descriptionController = TextEditingController(text: widget.postViewDto.post.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePost() async {
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      CustomSnackBar.show(context, '제목과 내용을 모두 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPost = widget.postViewDto.post.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      await context.read<PostProvider>().updatePost(context, updatedPost);
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '게시글 수정',
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _handleUpdatePost,
              child: Text(
                '완료',
                style: TextStyle(
                  color: _isLoading ? Colors.grey : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 1,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: null,
                minLines: 5,
              ),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
