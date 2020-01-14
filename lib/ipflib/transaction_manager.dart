import 'dart:async';
import 'dart:convert';

import '../corelib/utils.dart';

import 'db_manager.dart';
import 'models.dart';

class TransactionManager {
  var dbManager = DatabaseManager();

  TransactionManager();

  Future<int> createTransaction(
      String reason, Map<String, dynamic> extraData) async {
    int now = getTimestamp();

    String extraDataString = jsonEncode(extraData);

    Map<String, dynamic> data = {
      'reason': reason,
      'ctime': now,
      'mtime': now,
      'extra_data': extraDataString,
    };
    return dbManager.createTransaction(data);
  }

  Future<int> createUserTransaction(int userId, int transactionId) async {
    Map<String, dynamic> data = {
      'user_id': userId,
      'transaction_id': transactionId,
    };
    return dbManager.createUserTransaction(data);
  }
}
