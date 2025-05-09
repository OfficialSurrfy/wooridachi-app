import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uridachi/firebase_docs/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../methods/datasource/translation_methods.dart';
import '../models/bookmark_model.dart';
import '../models/global_post_model.dart';
import '../models/likes_model.dart';
import '../models/trending_post_model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StorageMethods storageMethods = StorageMethods();

  Future<String> uploadGlobalPost(
    String postId,
    String selectedType,
    String description,
    String user,
    String university,
    String profileImage,
    DateTime time,
    String title,
    String email,
    List<File> selectedImages,
  ) async {
    String res = "Some error occurred";
    try {
      String? translatedTitle = await translateText(title);
      String? translatedDescription = await translateText(description);

      List<String> imageUrls = [];
      String postType = "text";

      if (selectedType == "With Image") {
        postType = "image";

        for (File image in selectedImages) {
          String imageUrl = await storageMethods.uploadImageToStorage('global/$postId', image);
          imageUrls.add(imageUrl);
        }
      }

      GlobalPost post = GlobalPost(
        description: description,
        translatedDescription: translatedDescription,
        postId: postId,
        time: time,
        university: university,
        profileImage: profileImage,
        title: title,
        translatedTitle: translatedTitle,
        email: email,
        postType: postType,
        user: user,
        imageUrls: imageUrls,
      );

      await _firestore.collection('Global Posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadReport(
    String reportedUser,
    String reportedPostId,
    String reason,
    String? currentUserEmail,
  ) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('Reports').doc(reportedPostId).set({
        'reportedUser': reportedUser,
        'reportedPostId': reportedPostId,
        'reason': reason,
        'blacklisted': 'No',
        'reportingUser': FieldValue.arrayUnion([
          currentUserEmail
        ]),
      }, SetOptions(merge: true));

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadLikes(String postId) async {
    String res = "Some error occurred";
    try {
      Likes likes = Likes(
        postId: postId,
        likes: [],
      );
      await _firestore.collection('Likes').doc(postId).set(likes.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
