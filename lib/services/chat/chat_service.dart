import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uridachi/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to get chat rooms for the current user
  Stream<List<Map<String, dynamic>>> getChatRoomsStream(String currentUserID) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['chatRoomID'] = doc.id; // Add the chatRoomID to the data
        return data;
      }).toList();
    });
  }

  // Get user data from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      String userID) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: userID)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String userEmail = querySnapshot.docs.first.id;
      try {
        final userDoc =
            await _firestore.collection('users').doc(userEmail).get();
        if (userDoc.exists) {
          return userDoc;
        } else {
          throw Exception("User with ID $userEmail does not exist.");
        }
      } catch (e) {
        print('Error fetching user data for Email: $e');
        rethrow;
      }
    } else {
      throw Exception("User with ID $userID does not exist.");
    }
  }

  // Send a message to the chat room
  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_'); // Create chat room ID from user IDs

    Message newMessage = Message(
      senderId: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
      chatRoomID: chatRoomID,
      isRead: false, // Message is unread by default
    );

    DocumentReference chatRoomRef =
        _firestore.collection("chat_rooms").doc(chatRoomID);

    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    // If the chat room doesn't exist, create it
    if (!chatRoomSnapshot.exists) {
      await chatRoomRef.set({
        'participants': [currentUserID, receiverID],
        'createdAt': timestamp,
      });
    }

    // Add the new message to the messages subcollection
    await chatRoomRef.collection("messages").add(newMessage.toMap());
  }

  // Stream to get messages for the chat room
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Get the most recent message from the chat room
  Future<DocumentSnapshot<Map<String, dynamic>>> getMostRecentMessage(
      String chatRoomID) async {
    return await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty
            ? snapshot.docs.first
            : throw Exception('No messages found'));
  }

  Future<void> markMessagesAsRead(
      String chatRoomID, String currentUserID) async {
    final QuerySnapshot messagesSnapshot = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("receiverID", isEqualTo: currentUserID)
        .where("isRead", isEqualTo: false)
        .get();

    for (var doc in messagesSnapshot.docs) {
      await doc.reference.update({"isRead": true});
    }
  }

  Future<int> countUnreadMessages(
      String chatRoomID, String currentUserID) async {
    final QuerySnapshot unreadMessagesSnapshot = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("receiverID", isEqualTo: currentUserID)
        .where("isRead", isEqualTo: false)
        .get();
    return unreadMessagesSnapshot.docs.length;
  }
}
