import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_block_entity.dart';

part 'user_block_model.g.dart';

@JsonSerializable()
class UserBlockModel {
  final String id;
  final String blockerUserId;
  final String blockedUserId;
  final DateTime timestamp;

  UserBlockModel({
    required this.id,
    required this.blockerUserId,
    required this.blockedUserId,
    required this.timestamp,
  });

  factory UserBlockModel.fromJson(Map<String, dynamic> json) => _$UserBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserBlockModelToJson(this);

  UserBlockEntity toEntity() => UserBlockEntity(
        id: id,
        blockerUserId: blockerUserId,
        blockedUserId: blockedUserId,
        timestamp: timestamp,
      );
}
