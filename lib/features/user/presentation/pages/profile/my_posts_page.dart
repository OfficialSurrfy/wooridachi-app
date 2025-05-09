import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/features/post/domain/entities/post_view_dto.dart';
import 'package:uridachi/features/post/presentation/providers/post_provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'my_postcard.dart';

class UsersPosts extends StatefulWidget {
  final String? currentUserEmail;

  const UsersPosts({super.key, required this.currentUserEmail});

  @override
  State<UsersPosts> createState() => _UsersPostsState();
}

class _UsersPostsState extends State<UsersPosts> {
  List<PostViewDto> posts = [];
  late final PostProvider _postProvider;

  @override
  void initState() {
    super.initState();
    _postProvider = context.read<PostProvider>();
    fetchUsersPosts();
  }

  Future<void> fetchUsersPosts() async {
    try {
      final fetchedPosts = await _postProvider.getCurrentUserPosts(context);
      setState(() {
        posts = fetchedPosts;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching posts: $error");
      }
    }
  }

  void onPostDeleted() {
    fetchUsersPosts();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
        title: Text(
          localization.my_posts,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.001093 * 5),
            Divider(),
            SizedBox(height: screenHeight * 0.001093 * 5),
            Flexible(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final postData = posts[index];
                  return Column(
                    children: [
                      MyPostcard(
                        snap: postData,
                        onPostDeleted: onPostDeleted,
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.001093 * 5),
          ],
        ),
      ),
    );
  }
}
