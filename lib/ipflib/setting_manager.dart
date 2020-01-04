import 'dart:async';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

import 'package:i_pay_first/utilities/state_model.dart';

class SettingManager {
  StateWithUpdate _view;

  var dbManager = DatabaseManager();

  SettingManager(this._view);

  Future<int> createSetting(Setting setting) async {
    return dbManager.createSetting(setting);
  }

  Future<Setting> getSettingBySettingId(int settingId) async {
    return dbManager.getSettingBySettingId(settingId);
  }

  Future<bool> updateSetting(Setting setting) async {
    return dbManager.updateSetting(setting);
  }

  updateScreen() {
    _view.screenUpdate();
  }
}
