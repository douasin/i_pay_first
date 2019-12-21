import 'dart:async';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

import 'package:i_pay_first/utilities/state_model.dart';

class UserManager {
  StateWithUpdate _view;

  var dbManager = DatabaseManager();

  UserManager(this._view);

  delete(int userId) {
    var dbManager = DatabaseManager();
    dbManager.deleteUserByUserId(userId);
    updateScreen();
  }

  Future<List<User>> getUsers() async {
    return dbManager.getUsers();
  }

  updateScreen() {
    _view.screenUpdate();
  }
}
