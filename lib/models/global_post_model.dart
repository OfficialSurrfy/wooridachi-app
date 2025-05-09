import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalPost {
  final String description;
  final String? translatedDescription;
  final String user;
  final String email;
  final String university;
  final String profileImage;
  final DateTime time;
  final String postId;
  final String title;
  final String? translatedTitle;
  final String postType;
  final List<String> imageUrls;

  const GlobalPost({
    required this.description,
    required this.translatedDescription,
    required this.user,
    required this.email,
    required this.university,
    required this.profileImage,
    required this.time,
    required this.postId,
    required this.title,
    required this.translatedTitle,
    required this.postType,
    required this.imageUrls,
  });

  static GlobalPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return GlobalPost(
      description: snapshot['description'],
      translatedDescription: snapshot['translatedDescription'],
      user: snapshot['user'],
      email: snapshot['email'],
      university: snapshot['university'],
      profileImage: snapshot['profileImage'],
      time: snapshot["time"],
      postId: snapshot['postId'],
      title: snapshot['title'],
      translatedTitle: snapshot['translatedTitle'],
      postType: snapshot["postType"],
      imageUrls: snapshot['imageUrls'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "translatedDescription": translatedDescription,
        'user': user,
        'email': email,
        'university': university,
        'profileImage': profileImage,
        'time': time,
        'postId': postId,
        'title': title,
        "translatedTitle": translatedTitle,
        'postType': postType,
        'imageUrls': imageUrls,
      };
}
