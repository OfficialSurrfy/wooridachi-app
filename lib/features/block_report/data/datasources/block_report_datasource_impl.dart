import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_report_model.dart';
import '../models/user_block_model.dart';
import 'block_report_datasource.dart';

class BlockReportDatasourceImpl extends BlockReportDatasource {
  final FirebaseFirestore _firestore;

  // Define collection names as static
  static const String blockedUsersCollection = 'user_blocks';
  static const String reportsCollection = 'user_reports';
  static const String blocksCollection = 'blocks';

  BlockReportDatasourceImpl(this._firestore);

  // Block User
  @override
  Future<List<UserBlockModel>> getBlockedUsers(String blockerUserId) async {
    try {
      final snapshot = await _firestore.collection(blockedUsersCollection).doc(blockerUserId).get();
      final blocks = snapshot.data()?[blocksCollection] as List<dynamic>? ?? [];

      return blocks.map((block) => UserBlockModel.fromJson(block as Map<String, dynamic>)).toList();
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> setUserBlockList(String blockerUserId, List<UserBlockModel> userBlockList) async {
    try {
      await _firestore.collection(blockedUsersCollection).doc(blockerUserId).set({
        blocksCollection: userBlockList.map((block) => block.toJson()).toList(),
      });

      return;
    } on FirebaseException {
      rethrow;
    }
  }

  // Report User
  @override
  Future<void> reportUser(UserReportModel userReportModel) async {
    try {
      await _firestore.collection(reportsCollection).doc(userReportModel.id).set(userReportModel.toJson());

      return;
    } on FirebaseException {
      rethrow;
    }
  }
}
