import 'dart:async';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

class UserManager {
  var dbManager = DatabaseManager();

  UserManager();

  Future<void> delete(int userId) async {
    await dbManager.deleteUserByUserId(userId);
  }

  Future<List<User>> getUsers() async {
    return dbManager.getUsers();
  }

  Future<int> getTotalBalance() async {
    List<User> users = await getUsers();
    int total = 0;
    for (var user in users) {
      total += user.balance;
    }
    return total;
  }
  // TODO: set null to userid, gettimestamp for ctime, mtime when create user
}
