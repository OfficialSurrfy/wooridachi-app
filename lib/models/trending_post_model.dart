import 'package:cloud_firestore/cloud_firestore.dart';

class TrendingPost {
  final String user;
  final String postId;
  final String krImageUrl;
  final String jpImageUrl;
  final String krDescriptionImageUrl;
  final String jpDescriptionImageUrl;
  final String profileImage;
  final DateTime time;

  const TrendingPost({
    required this.user,
    required this.postId,
    required this.krImageUrl,
    required this.jpImageUrl,
    required this.krDescriptionImageUrl,
    required this.jpDescriptionImageUrl,
    required this.profileImage,
    required this.time,
  });

  static TrendingPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TrendingPost(
      user: snapshot["user"],
      postId: snapshot["postId"],
      krImageUrl: snapshot['krImageUrl'],
      jpImageUrl: snapshot['jpImageUrl'],
      krDescriptionImageUrl: snapshot['krDescriptionImageUrl'],
      jpDescriptionImageUrl: snapshot['jpDescriptionImageUrl'],
      profileImage: snapshot['profileImage'],
      time: snapshot['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user,
        "postId": postId,
        'krImageUrl': krImageUrl,
        'jpImageUrl': jpImageUrl,
        'krDescriptionImageUrl': krDescriptionImageUrl,
        'jpDescriptionImageUrl': jpDescriptionImageUrl,
        'profileImage': profileImage,
        'time': time,
      };
}
