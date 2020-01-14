import 'dart:async';

import '../../corelib/utils.dart';

import '../transaction_manager.dart';
import '../user_manager.dart';
import '../models.dart';
import '../constants.dart';

class TransactionOperator {
  TransactionOperator();

  var transactionManager = TransactionManager();

  Future<Transaction> createTransaction(
      String payReason,
      List<User> existedUserList,
      List<User> newUserList,
      Map<int, int> userBalanceMap,
      Map<String, dynamic> extraData) async {
    int now = getTimeStamp();

    // STEP 1: create new user
    // STEP 2: create transaction
    // STEP 3: update balance for all user
    // STEP 4: link user with transaction
    return Transaction();
  }
}
