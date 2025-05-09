// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../models/user_model.dart' as model;
// import '../models/user_model.dart';

// class AuthMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<model.Users> getUserDetails() async {
//     User currentUser = _auth.currentUser!;

//     DocumentSnapshot documentSnapshot =
//         await _firestore.collection('users').doc(currentUser.uid).get();

//     return model.Users.fromSnap(documentSnapshot);
//   }

//   Future<void> storeFcmToken(String email) async {
//     String? fcmToken = await FirebaseMessaging.instance.getToken();
//     if (fcmToken != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(email).get();
//       Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//       List<dynamic> existingTokens = userData['fcmToken'] ?? [];

//       if (!existingTokens.contains(fcmToken)) {
//         await FirebaseFirestore.instance.collection('users').doc(email).update({
//           'fcmToken': FieldValue.arrayUnion([fcmToken])
//         });
//       }
//     }
//   }

//   Future<String> uploadUser(
//       String university,
//       String email,
//       String password,
//       String username,
//       String language,
//       ) async {
//     String res = "Some error occurred";
//     try {
//       email = email.trim();
//       UserCredential cred = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       Users users = Users(
//         university: university,
//         email: email,
//         password: password,
//         username: username,
//         language: language,
//         uid: cred.user!.uid,
//         role: 'User',
//         fcmToken: [],
//         profileImage: '',
//       );
//       await _firestore.collection('users').doc(email).set(users.toJson());

//       await storeFcmToken(email);
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }


// }
