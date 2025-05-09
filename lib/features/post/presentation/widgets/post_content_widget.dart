import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uridachi/widgets/send_button.dart';
import 'package:uridachi/widgets/translate_button.dart';
import '../../../../../widgets/global_sns_widgets/full_screen_image.dart';
import '../../../common/user_menu_utils.dart';
import '../../../user/presentation/providers/user_data_holder.dart';
import '../../domain/entities/post_view_dto.dart';
import '../providers/post_provider.dart';
import '../pages/upload_post_screen.dart';

class PostContentWidget extends StatefulWidget {
  final PostViewDto postViewDto;

  const PostContentWidget({
    super.key,
    required this.postViewDto,
  });

  @override
  State<PostContentWidget> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  bool showOriginal = true;
  bool _isLikeLoading = false;
  Timer? _likeDebounceTimer;

  @override
  void dispose() {
    _likeDebounceTimer?.cancel();
    super.dispose();
  }

  void _showOptionsMenu() {
    final bool isCurrentUserPost = widget.postViewDto.user.id == Provider.of<UserDataHolder>(context, listen: false).user?.id;

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
              if (isCurrentUserPost) ...[
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.black87),
                  title: const Text('게시글 수정', style: TextStyle(fontSize: 16, color: Colors.black87)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPostScreen(postViewDto: widget.postViewDto),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('게시글 삭제', style: TextStyle(color: Colors.red, fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation();
                  },
                ),
              ],
              if (!isCurrentUserPost) ...
          [      ListTile(
                  leading: const Icon(Icons.report, color: Colors.black87),
                  title: const Text('게시글 신고', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    PostProvider.showBlockDialog(context, widget.postViewDto.user.id, false);
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.black87),
                title: const Text('게시글 안보기', style: TextStyle(fontSize: 16)),
                onTap: () {
                  PostProvider.showReportDialog(context, widget.postViewDto.user.id);
                  Navigator.pop(context);
                },
              ),   ]
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
          title: const Text('게시글 삭제', style: TextStyle(color: Colors.black)),
          content: const Text('이 게시글을 삭제하시겠습니까?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<PostProvider>(context, listen: false).deletePost(context, widget.postViewDto.post.id);
              },
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLike() async {
    if (_isLikeLoading || _likeDebounceTimer?.isActive == true) return;

    _likeDebounceTimer?.cancel();
    _likeDebounceTimer = Timer(const Duration(milliseconds: 300), () {});

    setState(() {
      _isLikeLoading = true;
    });

    try {
      await Provider.of<PostProvider>(context, listen: false).handlePostLike(context, widget.postViewDto.post.id);
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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04854,
          vertical: screenHeight * 0.01093,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.005465),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildUserSection(screenWidth),
                Row(
                  children: [
                    TranslateButton(
                      onToggle: () {
                        setState(() {
                          showOriginal = !showOriginal;
                        });
                      },
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
            SizedBox(height: screenHeight * 0.005465),
            _buildPostContent(screenHeight, screenWidth),
            _buildPostActions(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(double screenWidth) {
    return GestureDetector(
      onTapDown: (details) {
        UserMenuUtils.showUserMenu(context, details.globalPosition, widget.postViewDto.user.id);
      },
      child: Row(
        children: [
          widget.postViewDto.user.profileImageUrl != ''
              ? ClipOval(
                  child: Image.network(
                    widget.postViewDto.user.profileImageUrl,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/Avatar.png',
                  width: 40,
                  height: 40,
                ),
          SizedBox(width: screenWidth * 0.036405),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.postViewDto.user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                  SizedBox(width: screenWidth * 0.02427),
                  Text(
                    timeago.format(
                      DateTime.fromMicrosecondsSinceEpoch(
                        widget.postViewDto.post.createdAt.microsecondsSinceEpoch,
                      ),
                      locale: 'en_custom',
                    ),
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
              Text(
                widget.postViewDto.user.university,
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostTitle(),
        SizedBox(height: screenHeight * 0.002186),
        _buildPostDescription(),
        SizedBox(height: screenHeight * 0.017488),
        if (widget.postViewDto.post.imageUrls?.isNotEmpty ?? false) _buildImageList(screenHeight, screenWidth),
        _buildPostFooter(screenHeight, screenWidth),
      ],
    );
  }

  Widget _buildPostTitle() {
    return Text(
      showOriginal ? widget.postViewDto.post.title : (widget.postViewDto.post.translatedTitle ?? '').trim(),
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
    );
  }

  Widget _buildPostDescription() {
    return Text(
      showOriginal ? widget.postViewDto.post.description : (widget.postViewDto.post.translatedDescription ?? '').trim(),
      style: const TextStyle(fontSize: 15, color: Colors.black, height: 1.5),
    );
  }

  Widget _buildImageList(double screenHeight, double screenWidth) {
    return SizedBox(
      height: screenHeight * 0.12023,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.postViewDto.post.imageUrls?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.019416),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: widget.postViewDto.post.imageUrls![index],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.postViewDto.post.imageUrls![index],
                    width: screenWidth * 0.29124,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostFooter(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.008744),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPostTime(screenWidth),
          _buildPostActions(screenWidth),
        ],
      ),
    );
  }

  Widget _buildPostTime(double screenWidth) {
    return Row(
      children: [
        Text(
          DateFormat('MM/dd').format(widget.postViewDto.post.createdAt.toLocal()),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(width: screenWidth * 0.007281),
        Text(
          DateFormat('HH:mm').format(widget.postViewDto.post.createdAt.toLocal()),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPostActions(double screenWidth) {
    return Row(
      children: [
        GestureDetector(
          onTap: _handleLike,
          child: Icon(
            widget.postViewDto.isLiked ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: const Color(0xfff68585),
          ),
        ),
        SizedBox(width: screenWidth * 0.009708),
        Text('${widget.postViewDto.post.likesCount}', style: const TextStyle(color: Color(0xfff68585))),
        SizedBox(width: screenWidth * 0.019416),
        GestureDetector(
          onTap: () {},
          child: Image.asset(
            'assets/images/message-circle (1).png',
            width: screenWidth * 0.04854,
          ),
        ),
        SizedBox(width: screenWidth * 0.009708),
        Text('${widget.postViewDto.post.commentsCount}', style: TextStyle(color: Color(0xff7994f2))),
        SizedBox(width: screenWidth * 0.019416),
        SendButton(postCreatorEmail: widget.postViewDto.user.email),
      ],
    );
  }
}
