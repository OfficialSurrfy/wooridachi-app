// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReportModel _$UserReportModelFromJson(Map<String, dynamic> json) =>
    UserReportModel(
      id: json['id'] as String,
      reporterUserId: json['reporterUserId'] as String,
      reportedUserId: json['reportedUserId'] as String,
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserReportModelToJson(UserReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterUserId': instance.reporterUserId,
      'reportedUserId': instance.reportedUserId,
      'reason': instance.reason,
      'timestamp': instance.timestamp.toIso8601String(),
    };
