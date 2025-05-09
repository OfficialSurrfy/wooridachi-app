import 'package:flutter/material.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/send_button.dart';
import '../../../block_report/presentation/providers/block_report_provider.dart';
import '../../../common/user_menu_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../user/presentation/providers/user_data_holder.dart';
import '../../domain/entities/comment_view_dto.dart';
import '../providers/post_provider.dart';
import 'post_replies_widget.dart';
import 'comment_input_modal.dart';
import 'dart:async';

class SingleCommentWidget extends StatefulWidget {
  final CommentViewDto commentView;

  const SingleCommentWidget({
    super.key,
    required this.commentView,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController replyController = TextEditingController();
  bool isTranslated = false;
  bool isLoading = false;
  final bool _isExpanded = false;
  bool _isLikeLoading = false;
  Timer? _likeDebounceTimer;

  @override
  void dispose() {
    replyController.dispose();
    _likeDebounceTimer?.cancel();
    super.dispose();
  }

  void _showOptionsMenu() {
    final bool isCurrentUserComment = widget.commentView.user.id == Provider.of<UserDataHolder>(context, listen: false).user?.id;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (isCurrentUserComment) ...[
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.black87),
                  title: const Text('댓글 수정', style: TextStyle(fontSize: 16, color: Colors.black87)),
                  onTap: () {
                    Navigator.pop(context);
                    CommentInputModal.show(
                      context,
                      postId: widget.commentView.comment.postId,
                      itemId: widget.commentView.comment.id,
                      initialText: widget.commentView.comment.content,
                      isEditing: true,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('댓글 삭제', style: TextStyle(color: Colors.red, fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation();
                  },
                ),
              ],
              if (!isCurrentUserComment)
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.black87),
                  title: const Text('댓글 신고', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement report comment
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('댓글 삭제', style: TextStyle(color: Colors.black)),
          content: const Text('이 댓글을 삭제하시겠습니까?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<PostProvider>(context, listen: false).deleteComment(context, widget.commentView.comment.postId, widget.commentView.comment.id);
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showCommentInput(String postId, String commentId) {
    if (!mounted) return;

    CommentInputModal.show(
      context,
      postId: postId,
      commentId: commentId,
    );
  }

  Future<void> _handleLike() async {
    // If a like operation is in progress or debounce timer is active, ignore the click
    if (_isLikeLoading || _likeDebounceTimer?.isActive == true) return;

    // Set debounce timer to prevent rapid clicks
    _likeDebounceTimer?.cancel();
    _likeDebounceTimer = Timer(const Duration(milliseconds: 300), () {});

    setState(() {
      _isLikeLoading = true;
    });

    try {
      await Provider.of<PostProvider>(context, listen: false).handleCommentLike(
        context,
        widget.commentView.comment.postId,
        widget.commentView.comment.id,
        widget.commentView.isLiked,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLikeLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Consumer<BlockReportProvider>(
      builder: (context, blockReportProvider, child) {
        if (blockReportProvider.isBlocked(widget.commentView.user.id)) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04854),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xffe8e8e8)),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01093),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.005465),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.008744),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildUserSection(screenWidth),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  isTranslated = !isTranslated;
                                }),
                                child: Image.asset(
                                  isTranslated ? 'assets/images/translate_on.png' : 'assets/images/translate_off.png',
                                  width: screenWidth * 0.002427 * 25,
                                  height: screenHeight * 0.001093 * 25,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02427),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: _showOptionsMenu,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildCommentContent(),
                  _buildCommentActions(screenWidth, screenHeight, localization),
                  if (widget.commentView.replies != null) _buildReplies(screenHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserSection(double screenWidth) {
    return GestureDetector(
      onTapDown: (details) {
        Future.microtask(() {
          UserMenuUtils.showUserMenu(context, details.globalPosition, widget.commentView.user.id);
        });
      },
      child: Row(
        children: [
          widget.commentView.user.profileImageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    widget.commentView.user.profileImageUrl,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/Avatar.png',
                  width: 30,
                  height: 30,
                ),
          SizedBox(width: screenWidth * 0.036405),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.commentView.user.username,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                  ),
                  SizedBox(width: screenWidth * 0.029124),
                  Text(
                    timeago.format(
                      widget.commentView.comment.createdAt,
                      locale: 'en_custom',
                    ),
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
              Text(
                widget.commentView.user.university,
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentContent() {
    return Row(children: [
      Text(
        isTranslated ? (widget.commentView.comment.translatedContent ?? widget.commentView.comment.content) : widget.commentView.comment.content,
        style: const TextStyle(color: Colors.black),
      )
    ]);
  }

  Widget _buildCommentActions(double screenWidth, double screenHeight, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.008744),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MM/dd').format(widget.commentView.comment.createdAt.toLocal()),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(width: screenWidth * 0.007281),
              Text(
                DateFormat('HH:mm').format(widget.commentView.comment.createdAt.toLocal()),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () => showCommentInput(widget.commentView.comment.postId, widget.commentView.comment.id),
                child: Text(
                  localization.reply,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              InkWell(
                onTap: _handleLike,
                child: Row(
                  children: [
                    Icon(
                      widget.commentView.isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: const Color(0xfff68585),
                    ),
                    SizedBox(width: screenWidth * 0.009708),
                    Text(
                      '${widget.commentView.comment.likesCount}',
                      style: const TextStyle(color: Color(0xfff68585)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              InkWell(
                onTap: () {}, // _confirmReport,
                child: Text(
                  localization.report,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              SendButton(
                postCreatorEmail: widget.commentView.user.email,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplies(double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.01093),
      child: PostRepliesWidget(
        replies: widget.commentView.replies ?? [],
      ),
    );
  }
}
