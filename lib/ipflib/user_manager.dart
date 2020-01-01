import 'dart:async';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

import 'package:i_pay_first/utilities/state_model.dart';

class UserManager {
  StateWithUpdate _view;

  var dbManager = DatabaseManager();

  UserManager(this._view);

  Future<void> delete(int userId) async {
    await dbManager.deleteUserByUserId(userId);
    updateScreen();
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

  updateScreen() {
    _view.screenUpdate();
  }
}
