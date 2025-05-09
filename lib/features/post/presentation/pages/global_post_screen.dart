import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';

import '../providers/post_provider.dart';
import '../widgets/post_comments_widget.dart';
import '../widgets/post_content_widget.dart';
import 'package:uridachi/features/post/domain/entities/post_view_dto.dart';
import '../widgets/comment_input_modal.dart';

class GlobalPostScreen extends StatefulWidget {
  final PostViewDto postViewDto;

  const GlobalPostScreen({
    super.key,
    required this.postViewDto,
  });

  @override
  State<GlobalPostScreen> createState() => _GlobalPostScreenState();
}

class _GlobalPostScreenState extends State<GlobalPostScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  late PostViewDto _currentPostViewDto;

  @override
  void initState() {
    super.initState();
    _currentPostViewDto = widget.postViewDto;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PostProvider>().clearComments();
        _loadComments();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to post updates
    final postProvider = Provider.of<PostProvider>(context);
    final updatedPost = postProvider.globalPosts.firstWhere(
      (p) => p.post.id == _currentPostViewDto.post.id,
      orElse: () => _currentPostViewDto,
    );
    if (updatedPost != _currentPostViewDto) {
      setState(() {
        _currentPostViewDto = updatedPost;
      });
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    await context.read<PostProvider>().fetchComments(context, widget.postViewDto.post.id);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAddComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    await context.read<PostProvider>().addComment(
          context,
          widget.postViewDto.post.id,
          _commentController.text.trim(),
        );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: _buildBody(screenHeight, screenWidth, localization),
          bottomNavigationBar: _buildCommentSection(screenHeight, screenWidth, localization),
        ),
      ),
    );
  }

  Widget _buildBody(double screenHeight, double screenWidth, AppLocalizations localization) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildSliverAppBar(screenHeight),
        SliverList(
          delegate: SliverChildListDelegate([
            PostContentWidget(postViewDto: _currentPostViewDto),
            Consumer<PostProvider>(
              builder: (context, provider, child) {
                return PostCommentsWidget(comments: provider.comments);
              },
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.008744),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.008744),
          child: Text(
            'Global Post Screen',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      centerTitle: false,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.07651),
        child: Divider(
          color: Color(0xffe8e8e8),
        ),
      ),
    );
  }

  Widget _buildCommentSection(double screenHeight, double screenWidth, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02427,
        right: screenWidth * 0.04854,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.017488),
        child: GestureDetector(
          onTap: () {
            CommentInputModal.show(
              context,
              postId: widget.postViewDto.post.id,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02427),
                    child: Text(
                      localization.write_a_comment,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Color(0xff582ab2)),
                  onPressed: () {
                    CommentInputModal.show(
                      context,
                      postId: widget.postViewDto.post.id,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
