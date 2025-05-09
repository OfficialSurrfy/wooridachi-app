import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_report_entity.dart';

part 'user_report_model.g.dart';

@JsonSerializable()
class UserReportModel {
  final String id;
  final String reporterUserId;
  final String reportedUserId;
  final String reason;
  final DateTime timestamp;

  UserReportModel({
    required this.id,
    required this.reporterUserId,
    required this.reportedUserId,
    required this.reason,
    required this.timestamp,
  });

  factory UserReportModel.fromJson(Map<String, dynamic> json) => _$UserReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserReportModelToJson(this);

  UserReportEntity toEntity() => UserReportEntity(
        id: id,
        reporterUserId: reporterUserId,
        reportedUserId: reportedUserId,
        reason: reason,
        timestamp: timestamp,
      );
}
