// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBlockModel _$UserBlockModelFromJson(Map<String, dynamic> json) =>
    UserBlockModel(
      id: json['id'] as String,
      blockerUserId: json['blockerUserId'] as String,
      blockedUserId: json['blockedUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserBlockModelToJson(UserBlockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'blockerUserId': instance.blockerUserId,
      'blockedUserId': instance.blockedUserId,
      'timestamp': instance.timestamp.toIso8601String(),
    };
