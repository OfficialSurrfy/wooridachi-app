import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import '../../../block_report/presentation/widgets/custom_snack_bar.dart';
import '../../../user/presentation/providers/user_data_holder.dart';
import '../providers/post_provider.dart';

class CommentInputModal extends StatefulWidget {
  final String postId;
  final String? commentId; // Optional - if provided, this is a reply to a comment
  final String? itemId; // ID of the comment/reply being edited
  final String? initialText; // Initial text for editing
  final bool isEditing; // Whether we're editing or creating
  final bool isReply; // Whether this is a reply or comment
  final Function? onSubmitComplete;

  const CommentInputModal({
    super.key,
    required this.postId,
    this.commentId,
    this.itemId,
    this.initialText,
    this.isEditing = false,
    this.isReply = false,
    this.onSubmitComplete,
  });

  static void show(
    BuildContext context, {
    required String postId,
    String? commentId,
    String? itemId,
    String? initialText,
    bool isEditing = false,
    bool isReply = false,
    Function? onSubmitComplete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CommentInputModal(
        postId: postId,
        commentId: commentId,
        itemId: itemId,
        initialText: initialText,
        isEditing: isEditing,
        isReply: isReply,
        onSubmitComplete: onSubmitComplete,
      ),
    );
  }

  @override
  State<CommentInputModal> createState() => _CommentInputModalState();
}

class _CommentInputModalState extends State<CommentInputModal> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _textController.text = widget.initialText!;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final postProvider = Provider.of<PostProvider>(context, listen: false);

    try {
      if (widget.isEditing) {
        if (widget.isReply) {
          final userId = Provider.of<UserDataHolder>(context, listen: false).user?.id;

          if (userId == null) {
            CustomSnackBar.show(context, '유저 정보를 불러오는 중 오류가 발생했습니다.');
            return;
          }

          await postProvider.updateReply(
            context,
            widget.postId,
            widget.itemId!,
            _textController.text.trim(),
            userId,
          );
        } else {
          final userId = Provider.of<UserDataHolder>(context, listen: false).user?.id;

          if (userId == null) {
            CustomSnackBar.show(context, '유저 정보를 불러오는 중 오류가 발생했습니다.');
            return;
          }

          await postProvider.updateComment(
            context,
            widget.postId,
            widget.itemId!,
            _textController.text.trim(),
            userId,
          );
        }
      } else {
        if (widget.commentId != null) {
          // Add new reply
          await postProvider.addReply(
            context,
            widget.postId,
            widget.commentId!,
            _textController.text.trim(),
          );
        } else {
          // Add new comment
          await postProvider.addComment(
            context,
            widget.postId,
            _textController.text.trim(),
          );
        }
      }

      if (mounted) {
        widget.onSubmitComplete?.call();
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
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
    final localization = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    String hintText = widget.isEditing
        ? widget.isReply
            ? localization.edit_reply
            : localization.edit_comment
        : widget.commentId != null
            ? localization.write_a_reply
            : localization.write_a_comment;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          if (widget.isEditing)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.isReply ? localization.edit_reply : localization.edit_comment,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          // Input section
          Container(
            height: screenHeight * 0.08,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04854,
              vertical: screenHeight * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.black),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: hintText,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xff582BA8),
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Icon(Icons.send, color: Color(0xff582BA8)),
                  onPressed: _isLoading ? null : _handleSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
