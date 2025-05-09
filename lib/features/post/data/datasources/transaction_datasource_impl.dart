import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction_datasource.dart';

class TransactionDatasourceImpl implements TransactionDatasource {
  final FirebaseFirestore _firestore;

  TransactionDatasourceImpl(this._firestore);

  @override
  Future<void> run(Future<void> Function(Transaction) action) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await action(transaction);
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
