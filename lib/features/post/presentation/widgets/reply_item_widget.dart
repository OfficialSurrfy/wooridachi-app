import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../widgets/send_button.dart';
import '../../../common/user_menu_utils.dart';
import '../../domain/entities/reply_view_dto.dart';
import '../providers/post_provider.dart';
import '../../../user/presentation/providers/user_data_holder.dart';
import 'comment_input_modal.dart';

class ReplyItemWidget extends StatefulWidget {
  final ReplyViewDto replyViewDto;

  const ReplyItemWidget({
    super.key,
    required this.replyViewDto,
  });

  @override
  State<ReplyItemWidget> createState() => _ReplyItemWidgetState();
}

class _ReplyItemWidgetState extends State<ReplyItemWidget> {
  final TextEditingController replyController = TextEditingController();
  bool isTranslated = false;
  bool isSending = false;
  bool _isLikeLoading = false;
  Timer? _likeDebounceTimer;

  @override
  void dispose() {
    replyController.dispose();
    _likeDebounceTimer?.cancel();
    super.dispose();
  }

  void _showOptionsMenu() {
    final bool isCurrentUserReply = widget.replyViewDto.user.id == Provider.of<UserDataHolder>(context, listen: false).user?.id;

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
              if (isCurrentUserReply) ...[
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.black87),
                  title: const Text('답글 수정', style: TextStyle(fontSize: 16, color: Colors.black87)),
                  onTap: () {
                    Navigator.pop(context);
                    CommentInputModal.show(
                      context,
                      postId: widget.replyViewDto.reply.postId,
                      itemId: widget.replyViewDto.reply.id,
                      initialText: widget.replyViewDto.reply.content,
                      isEditing: true,
                      isReply: true,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('답글 삭제', style: TextStyle(color: Colors.red, fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation();
                  },
                ),
              ],
              if (!isCurrentUserReply)
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.black87),
                  title: const Text('답글 신고', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement report reply
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
          title: const Text('답글 삭제', style: TextStyle(color: Colors.black)),
          content: const Text('이 답글을 삭제하시겠습니까?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<PostProvider>(context, listen: false).deleteReply(context, widget.replyViewDto.reply.postId, widget.replyViewDto.reply.id);
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showCommentInput() {
    if (!mounted) return;

    CommentInputModal.show(
      context,
      postId: widget.replyViewDto.reply.postId,
      commentId: widget.replyViewDto.reply.commentId,
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
      await Provider.of<PostProvider>(context, listen: false).handleReplyLike(
        context,
        widget.replyViewDto.reply.postId,
        widget.replyViewDto.reply.commentId,
        widget.replyViewDto.reply.id,
        widget.replyViewDto.isLiked,
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

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfff9f9f9),
        border: Border(
          top: BorderSide(color: Color(0xffe8e8e8)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04854,
          vertical: screenHeight * 0.01093,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.005465),
            _buildUserSection(screenWidth),
            SizedBox(height: screenHeight * 0.005465),
            _buildReplyContent(),
            _buildReplyActions(screenWidth, screenHeight, localization),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.008744),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTapDown: (details) {
                Future.microtask(() {
                  UserMenuUtils.showUserMenu(context, details.globalPosition, widget.replyViewDto.user.id);
                });
              },
              child: Row(
                children: [
                  widget.replyViewDto.user.profileImageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            widget.replyViewDto.user.profileImageUrl,
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
                            widget.replyViewDto.user.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.029124),
                          Text(
                            timeago.format(
                              widget.replyViewDto.reply.createdAt,
                              locale: 'en_custom',
                            ),
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        widget.replyViewDto.user.university,
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    isTranslated = !isTranslated;
                  }),
                  child: Image.asset(
                    isTranslated ? 'assets/images/translate_on.png' : 'assets/images/translate_off.png',
                    width: screenWidth * 0.002427 * 25,
                    height: MediaQuery.of(context).size.height * 0.001093 * 25,
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
    );
  }

  Widget _buildReplyContent() {
    return Row(
      children: [
        Expanded(
          child: Text(
            isTranslated ? (widget.replyViewDto.reply.translatedContent ?? widget.replyViewDto.reply.content) : widget.replyViewDto.reply.content,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildReplyActions(double screenWidth, double screenHeight, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.008744),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MM/dd').format(widget.replyViewDto.reply.createdAt.toLocal()),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(width: screenWidth * 0.007281),
              Text(
                DateFormat('HH:mm').format(widget.replyViewDto.reply.createdAt.toLocal()),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: showCommentInput,
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
                      widget.replyViewDto.isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: const Color(0xfff68585),
                    ),
                    SizedBox(width: screenWidth * 0.009708),
                    Text(
                      '${widget.replyViewDto.reply.likesCount}',
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
                postCreatorEmail: widget.replyViewDto.user.email,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
