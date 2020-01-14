import 'dart:async';

import '../corelib/utils.dart';

import 'db_manager.dart';
import 'models.dart';

class SettingManager {
  var dbManager = DatabaseManager();

  SettingManager();

  Future<int> createSetting(int settingId, String value) async {
    int now = getTimestamp();

    Map<String, dynamic> data = {
      'setting_id': settingId,
      'value': value,
      'ctime': now,
      'mtime': now,
    };

    return dbManager.createSetting(data);
  }

  Future<Setting> getSettingBySettingId(int settingId) async {
    return dbManager.getSettingBySettingId(settingId);
  }

  Future<bool> updateSetting(Setting setting) async {
    return dbManager.updateSetting(setting);
  }
}
