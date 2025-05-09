// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_docs/auth_methods.dart';
// import 'models/user_model.dart' as app_user;

// class UserProvider with ChangeNotifier {

//   app_user.Users? _user;
//   final AuthMethods _authMethods = AuthMethods();

//   app_user.Users get getUser => _user!;

//   Future<app_user.Users?> getCurrentUser(String? userEmail) async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
//       if (snapshot.exists) {
//         return app_user.Users.fromSnap(snapshot);
//       } else {
//         return null; // User not found in Firestore
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error getting user data: $e");
//       } 
//       return null; // Error occurred while fetching user data
//     }
//   }

//   Future<void> refreshUser() async {
//     app_user.Users user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }
