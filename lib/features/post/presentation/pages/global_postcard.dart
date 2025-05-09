import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/widgets/send_button.dart';
import '../../../block_report/presentation/providers/block_report_provider.dart';
import '../../../common/user_menu_utils.dart';
import '../../../../widgets/translate_button.dart';
import '../../domain/entities/post_view_dto.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart' as intl;

import '../providers/post_provider.dart';
import 'global_post_screen.dart';

class GlobalPostcard extends StatefulWidget {
  final PostViewDto postViewDto;
  final bool isPreview;

  const GlobalPostcard({super.key, required this.postViewDto, required this.isPreview});

  @override
  State<GlobalPostcard> createState() => _GlobalPostcardState();
}

class _GlobalPostcardState extends State<GlobalPostcard> {
  bool showOriginal = true;
  bool _isLikeLoading = false;

  void setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('Stack Trace: ${record.stackTrace}');
      }
    });
  }

  void toggleShowOriginal() {
    setState(() {
      showOriginal = !showOriginal;
    });
  }

  Future<void> _handleLike() async {
    if (_isLikeLoading) return;

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
  void initState() {
    super.initState();
    setupLogging();
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<BlockReportProvider>(
      builder: (context, blockReportProvider, child) {
        if (blockReportProvider.isBlocked(widget.postViewDto.user.id)) {
          return SizedBox.shrink();
        }

        return Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(context, screenWidth, screenHeight),
              _buildContentSection(context, screenWidth, screenHeight)
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection(BuildContext context, double screenWidth, double screenHeight) {
    final post = widget.postViewDto.post;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GlobalPostScreen(postViewDto: widget.postViewDto)));
      },
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: screenWidth * 0.018281),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.03,
          ),
          child: Text(
            showOriginal ? post.title : (post.translatedTitle ?? post.title),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.05,
          ),
          child: Text(
            showOriginal ? post.description : (post.translatedDescription ?? post.description),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.013116),
            child: SizedBox(
              height: screenHeight * 0.1093,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.imageUrls!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.019416),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        post.imageUrls![index],
                        width: screenWidth * 0.26697,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  intl.DateFormat('MM/dd').format(post.createdAt.toLocal()),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(width: screenWidth * 0.007281),
                Text(
                  intl.DateFormat('HH:mm').format(post.createdAt.toLocal()),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Row(
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
                Text(
                  '${post.likesCount}',
                  style: const TextStyle(color: Color(0xfff68585)),
                ),
                SizedBox(width: screenWidth * 0.019416),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/message-circle (1).png',
                      width: screenWidth * 0.002427 * 22,
                      height: screenHeight * 0.001093 * 22,
                    ),
                    SizedBox(width: screenWidth * 0.009708),
                    Text(
                      '${post.commentsCount}',
                      style: TextStyle(color: Color(0xff738ee9)),
                    ),
                  ],
                ),
                SizedBox(width: screenWidth * 0.019416),
                SendButton(
                  postCreatorEmail: widget.postViewDto.user.email,
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildTopSection(BuildContext context, double screenWidth, double screenHeight) {
    final user = widget.postViewDto.user;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            user.profileImageUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.profileImageUrl,
                      width: 40,
                      height: 40,
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
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.00127),
                  child: Row(
                    children: [
                      Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                      SizedBox(width: screenWidth * 0.02427),
                      Text(
                        timeago.format(
                          widget.postViewDto.post.createdAt,
                          locale: 'en_custom',
                        ),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  user.university ?? '',
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        TranslateButton(onToggle: toggleShowOriginal),
      ],
    );
  }
}
