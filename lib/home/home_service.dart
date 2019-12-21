import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

abstract class HomeService {
  void screenUpdate();
}

class HomeService {
  HomeService _view;

  Database db = DatabaseManager();

  HomeService(this._view);

  delete(int user_id) {
    Database db = DatabaseManager();
    db.deleteUserByUserId(user_id);
    updateScreen();
  }

  Future<List<User>> getUser() {
    return db.getUser();
  }

  updateScren() {
    _view.screenUpdate();
  }
}
