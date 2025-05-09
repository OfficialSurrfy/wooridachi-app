import '../../data/models/user_report_model.dart';

class UserReportEntity {
  final String id;
  final String reporterUserId;
  final String reportedUserId;
  final String reason;
  final DateTime timestamp;

  UserReportEntity({
    required this.id,
    required this.reporterUserId,
    required this.reportedUserId,
    required this.reason,
    required this.timestamp,
  });

  UserReportModel toModel() => UserReportModel(
        id: id,
        reporterUserId: reporterUserId,
        reportedUserId: reportedUserId,
        reason: reason,
        timestamp: timestamp,
      );
}
