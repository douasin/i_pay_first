import 'dart:async';

import '../../corelib/utils.dart';

import '../transaction_manager.dart';
import '../user_manager.dart';
import '../models.dart';

class TransactionOperator {
  TransactionOperator();

  var transactionManager = TransactionManager();
  var userManager = UserManager();

  Future<void> createTransaction(String payReason, List<User> userList,
      Map<int, int> userBalanceMap, Map<String, dynamic> extraData) async {
    // STEP 1: create transaction
    int transactionId =
        await transactionManager.createTransaction(payReason, extraData);

    for (var user in userList) {
      int userId;
      if (isNewUser(user)) {
        // STEP 2-a: create new user with balance
        userId = await userManager.createUser(
            user.name, userBalanceMap[user.userId]);
      } else {
        // STEP 2-b: update balance for existed users
        user.balance += userBalanceMap[user.userId];
        await userManager.updateUser(user);
        userId = user.userId;
      }
      // STEP 3: link user with transaction
      transactionManager.createUserTransaction(user.userId, transactionId);
    }
  }
}
