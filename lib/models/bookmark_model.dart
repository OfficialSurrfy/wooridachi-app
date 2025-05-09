import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmarks {
  final String postId;
  final List<String> bookmarks;

  const Bookmarks({
    required this.postId,
    required this.bookmarks,
  });

  static Bookmarks fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Bookmarks(
      postId: snapshot['postId'],
      bookmarks: snapshot['bookmarks'],
    );
  }

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'bookmarks': bookmarks,};
}
