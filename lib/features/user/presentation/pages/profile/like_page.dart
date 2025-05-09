import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/features/post/presentation/providers/post_provider.dart';
import 'package:uridachi/features/post/presentation/widgets/post_content_widget.dart';
import 'package:uridachi/l10n/app_localizations.dart';

class UserLikes extends StatefulWidget {
  final String? currentUserEmail;

  const UserLikes({super.key, required this.currentUserEmail});

  @override
  State<UserLikes> createState() => _UserLikesState();
}

class _UserLikesState extends State<UserLikes> {
  late final PostProvider _postProvider;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _postProvider = context.read<PostProvider>();
      _fetchLikedPosts();
      _isInitialized = true;
    }
  }

  Future<void> _fetchLikedPosts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _postProvider.getUserLikedPosts(context);
      setState(() {
        _posts = posts;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> _posts = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.008744),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.001093 * 8),
          child: Text(
            localization.liked_posts,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.002427 * 10),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.001093 * 5),
            Divider(
              color: Colors.black,
            ),
            SizedBox(height: screenHeight * 0.001093 * 5),
            Flexible(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _fetchLikedPosts,
                      child: ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              PostContentWidget(
                                postViewDto: _posts[index],
                              ),
                              SizedBox(height: screenHeight * 0.001093 * 5),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
