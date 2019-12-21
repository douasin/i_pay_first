import 'dart:async';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

import 'package:i_pay_first/utilities/state_model.dart';

class UserManager {
  StateWithUpdate _view;

  var db_manager = DatabaseManager();

  UserManager(this._view);

  delete(int user_id) {
    var db_manager = DatabaseManager();
    db_manager.deleteUserByUserId(user_id);
    updateScreen();
  }

  Future<List<User>> getUsers() {
    return db_manager.getUsers();
  }

  updateScreen() {
    _view.screenUpdate();
  }
}
