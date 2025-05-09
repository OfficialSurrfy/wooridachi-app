
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String faculty;
  final List<String> bookmark;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final double rating;
  final String title;
  final String time;
  final double moneyRating;
  final String address;
  final String selectedPlace;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.bookmark,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.rating,
      required this.faculty,
      required this.title,
      required this.time,
      required this.moneyRating,
      required this.address,
      required this.selectedPlace});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        bookmark: snapshot["likes"],
        postId: snapshot["postId"],
        faculty: snapshot["faculty"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        rating: snapshot['rating'],
        title: snapshot['title'],
        time: snapshot['time'],
        moneyRating: snapshot['moneyRating'],
        address: snapshot['address'],
        selectedPlace: snapshot['selectedPlace']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "bookmark": bookmark,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'rating': rating,
        'title': title,
        'time': time,
        'faculty': faculty,
        'moneyRating': moneyRating,
        'address': address,
        'selectedPlace': selectedPlace
      };
}
