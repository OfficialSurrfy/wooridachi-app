import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String senderId;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Chat({
    required this.senderId,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  static Chat fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Chat(
        senderId: snapshot['senderId'],
        senderEmail: snapshot['senderEmail'],
        receiverID: snapshot['receiverID'],
        message: snapshot['message'],
        timestamp: snapshot['timestamp']);
  }

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    'senderEmail': senderEmail,
    'receiverID': receiverID,
    'message': message,
    'timestamp': timestamp,
  };
}
