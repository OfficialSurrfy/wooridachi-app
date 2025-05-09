import 'package:cloud_firestore/cloud_firestore.dart';

class Likes {
  final String postId;
  final List<String> likes;

  const Likes({
    required this.postId,
    required this.likes,
  });

  static Likes fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Likes(
      postId: snapshot['postId'],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'likes': likes,
      };
}
