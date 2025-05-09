import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String university;
  final String email;
  final String password;
  final String username;
  final String language;
  final String uid;
  final String role;
  final List<String> fcmToken;
  final String profileImage;

  Users({
    required this.university,
    required this.email,
    required this.password,
    required this.username,
    required this.language,
    required this.uid,
    required this.role,
    required this.fcmToken,
    required this.profileImage,
  });

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      university: snapshot['university'],
      email: snapshot['email'],
      password: snapshot['password'],
      username: snapshot['username'],
      language: snapshot['nationality'],
      uid: snapshot['uid'],
      role: snapshot['role'],
      fcmToken: List<String>.from(snapshot['fcmToken'] ?? []),
      profileImage: snapshot['profileImage'],
    );
  }

  Users copyWith({
    String? university,
    String? email,
    String? password,
    String? username,
    String? language,
    String? uid,
    String? role,
    List<String>? fcmToken,
    String? profileImage,
  }) {
    return Users(
      university: university ?? this.university,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      language: language ?? this.language,
      uid: uid ?? this.uid,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'university': university,
      'email': email,
      'password': password,
      'username': username,
      'language': language,
      'uid': uid,
      'role': role,
      'fcmToken': fcmToken.toList(),
      'imageUrls': profileImage,
    };
  }
}
