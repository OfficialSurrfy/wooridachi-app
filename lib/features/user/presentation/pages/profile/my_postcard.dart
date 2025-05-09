import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:uridachi/widgets/send_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart' as intl;
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/post/domain/entities/post_view_dto.dart';
import '../../../../post/presentation/pages/global_post_screen.dart';

class MyPostcard extends StatefulWidget {
  final PostViewDto snap;
  final VoidCallback onPostDeleted;

  const MyPostcard({super.key, required this.snap, required this.onPostDeleted});

  @override
  State<MyPostcard> createState() => _MyPostcardState();
}

class _MyPostcardState extends State<MyPostcard> {
  bool isLoading = false;
  int likeCount = 0;
  int commentCount = 0;
  bool isLiked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isTranslating = false;
  String? translatedDescription;
  String? translatedTitle;
  bool isExpanded = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('GlobalPostcardLogger');
  Icon likeIcon = const Icon(
    Icons.favorite_border,
    color: Color(0xfff68585),
  );
  final int maxRetries = 5;

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

  @override
  void initState() {
    super.initState();
    setupLogging();
    likeCount = widget.snap.post.likesCount;
    commentCount = widget.snap.post.commentsCount;
    isLiked = widget.snap.isLiked;
    updateLikeIcon();
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  }

  void updateLikeIcon() {
    if (isLiked) {
      likeIcon = const Icon(Icons.favorite, color: Color(0xfff68585));
    } else {
      likeIcon = const Icon(
        Icons.favorite_border,
        color: Color(0xfff68585),
      );
    }
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Delete Post", style: TextStyle(color: Colors.black)),
              content: const Text("Are you sure you want to delete it?", style: TextStyle(color: Colors.black)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.black87))),
                TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection("Comments").where('postId', isEqualTo: widget.snap.post.id).get().then((querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          doc.reference.delete();
                        }
                      }).catchError((error) {
                        print("Error deleting documents: $error");
                      });

                      await FirebaseFirestore.instance.collection("Replies").where('postId', isEqualTo: widget.snap.post.id).get().then((querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          doc.reference.delete();
                        }
                      }).catchError((error) {
                        print("Error deleting documents: $error");
                      });

                      await FirebaseFirestore.instance.collection("Likes").doc(widget.snap.post.id).delete().catchError((error) {
                        print("Error deleting likes: $error");
                      });

                      await FirebaseFirestore.instance.collection("Global Posts").doc(widget.snap.post.id).delete().then((_) {
                        widget.onPostDeleted();
                        Navigator.pop(context);
                      }).catchError((error) {
                        print("Error deleting post: $error");
                      });
                    },
                    child: const Text("Delete")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GlobalPostScreen(postViewDto: widget.snap),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.snap.user.profileImageUrl != ''
                        ? ClipOval(
                            child: Image.network(
                              widget.snap.user.profileImageUrl,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/Avatar.png',
                          ),
                    SizedBox(width: screenWidth * 0.036405),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.snap.user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                            SizedBox(width: screenWidth * 0.02427),
                            Text(
                              timeago.format(
                                widget.snap.post.createdAt,
                                locale: 'en_custom',
                              ),
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          localization.university_name,
                          style: TextStyle(color: Colors.grey[400], fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      deletePost();
                    },
                    child: Image.asset(
                      'assets/images/trash-2.png',
                      width: 25,
                      height: 25,
                    ))
              ],
            ),
            SizedBox(height: screenWidth * 0.007281),
            Text(
              widget.snap.post.translatedTitle ?? widget.snap.post.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: Text(
                widget.snap.post.translatedDescription ?? widget.snap.post.description,
                style: TextStyle(fontSize: 15, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.snap.post.imageUrls != null && widget.snap.post.imageUrls!.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.013116),
                child: SizedBox(
                  height: screenHeight * 0.1093,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.snap.post.imageUrls!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.019416),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.snap.post.imageUrls![index],
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
                      intl.DateFormat('MM/dd').format(widget.snap.post.createdAt.toLocal()),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      width: screenWidth * 0.007281,
                    ),
                    Text(
                      intl.DateFormat('HH:mm').format(widget.snap.post.createdAt.toLocal()),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: const Color(0xfff68585),
                    ),
                    SizedBox(
                      width: screenWidth * 0.009708,
                    ),
                    Text(
                      '$likeCount',
                      style: const TextStyle(color: Color(0xfff68585)),
                    ),
                    SizedBox(
                      width: screenWidth * 0.019416,
                    ),
                    Image.asset('assets/images/message-circle (1).png', width: screenWidth * 0.04854, height: screenHeight * 0.02186),
                    SizedBox(
                      width: screenWidth * 0.009708,
                    ),
                    Text(
                      '$commentCount',
                      style: TextStyle(color: Color(0xff738ee9)),
                    ),
                    SizedBox(
                      width: screenWidth * 0.019416,
                    ),
                    SendButton(
                      postCreatorEmail: widget.snap.user.email,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
