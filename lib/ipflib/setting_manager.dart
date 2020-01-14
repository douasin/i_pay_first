import 'dart:async';

import 'package:i_pay_first/ipflib/db_manager.dart';
import 'package:i_pay_first/ipflib/models.dart';

class SettingManager {
  var dbManager = DatabaseManager();

  SettingManager();

  Future<int> createSetting(Setting setting) async {
    return dbManager.createSetting(setting);
  }

  Future<Setting> getSettingBySettingId(int settingId) async {
    return dbManager.getSettingBySettingId(settingId);
  }

  Future<bool> updateSetting(Setting setting) async {
    return dbManager.updateSetting(setting);
  }
}
