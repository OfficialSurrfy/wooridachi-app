import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;
  final String chatRoomID;
  final bool isRead;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
    required this.chatRoomID,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderId,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
      'chatRoomID': chatRoomID,
      'isRead': isRead,
    };
  }
}
