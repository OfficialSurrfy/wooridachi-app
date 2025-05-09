import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reportedUser;
  final List<String> reportingUser;
  final String reportedPostId;
  final String reason;
  final String blacklisted;

  Report({
    required this.reportedUser,
    required this.reportingUser,
    required this.reportedPostId,
    required this.reason,
    required this.blacklisted,
  });

  static Report fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Report(
        reportedUser: snapshot['reportedUser'],
        reportingUser: snapshot['reportingUser'],
        reportedPostId: snapshot['reportedPostId'],
        reason: snapshot['reason'],
        blacklisted: snapshot['blacklisted']);
  }

  Map<String, dynamic> toJson() => {
    "reportedUser": reportedUser,
    'reportingUser': reportingUser,
    'reportedPostId': reportedPostId,
    'reason': reason,
    'blacklisted': blacklisted,
  };
}
