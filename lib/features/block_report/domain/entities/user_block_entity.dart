import '../../data/models/user_block_model.dart';

class UserBlockEntity {
  final String id;
  final String blockerUserId;
  final String blockedUserId;
  final DateTime timestamp;

  UserBlockEntity({
    required this.id,
    required this.blockerUserId,
    required this.blockedUserId,
    required this.timestamp,
  });

  UserBlockModel toModel() => UserBlockModel(
        id: id,
        blockerUserId: blockerUserId,
        blockedUserId: blockedUserId,
        timestamp: timestamp,
      );
}
