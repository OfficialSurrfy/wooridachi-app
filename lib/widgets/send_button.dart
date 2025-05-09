import 'package:flutter/material.dart';
import 'package:uridachi/services/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screen/chat_screens/chat_view_page.dart';

class SendButton extends StatelessWidget {
  final String postCreatorEmail;

  const SendButton({
    super.key,
    required this.postCreatorEmail,
  });

  Future<Map<String, dynamic>?> fetchUserDetailsByEmail(
      String userEmail) async {
    var usersCollection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await usersCollection
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null; // User not found or error
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Image.asset('assets/images/send (2).png',
          width: screenWidth * 0.002427 * 20,
          height: screenHeight * 0.001093 * 20),
      onTap: () async {
        final currentUserEmail = authService.getCurrentUser()?.email;
        if (currentUserEmail == null || currentUserEmail == postCreatorEmail) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Oops!"),
              content: const Text("You cannot chat with yourself."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return;
        }

        var userDetails = await fetchUserDetailsByEmail(postCreatorEmail);
        if (userDetails != null) {
          String receiverUsername = userDetails['username'] ?? 'Unknown';
          String receiverID = userDetails['uid'] ?? 'Unknown';
          String receiverUniversity = userDetails["university"] ?? "Unknown";

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatViewPage(
                  receiverEmail: postCreatorEmail,
                  receiverUsername: receiverUsername,
                  receiverID: receiverID,
                  receiverUniversity: receiverUniversity),
            ),
          );
        } else {
          print("Error fetching user details for chat.");
        }
      },
    );
  }
}
