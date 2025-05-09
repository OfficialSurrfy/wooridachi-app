import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TransactionDatasource {
  Future<void> run(Future<void> Function(Transaction) action);
}
