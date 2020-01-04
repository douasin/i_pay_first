import 'dart:async';

import '../../corelib/utils.dart';

import '../setting_manager.dart';
import '../models.dart';
import '../constants.dart';
import '../../utilities/state_model.dart';

String formatValueByType(dynamic value, SettingType type) {
  if (type == SettingType.string) {
    return value;
  } else if (type == SettingType.double) {
    return value.toStringAsFixed(systemDecimal);
  }
  // TODO: more type
  return "";
}

class SettingOperator {
  StateWithUpdate _view;

  SettingOperator(this._view);

  Future<Setting> getOrCreateSettingBySettingName(
      SettingName settingName) async {
    var settingManager = SettingManager(_view);
    int settingId = SettingNameNameToValue[settingName];
    Setting setting = await settingManager.getSettingBySettingId(settingId);
    if (setting != null) {
      return setting;
    }
    int now = getTimeStamp();
    SettingType type = SettingTypeConfig[settingName];
    setting = Setting(
      settingId: settingId,
      type: SettingTypeNameToValue[type],
      value: formatValueByType(
        SettingDefaultValue[settingName],
        type,
      ),
      ctime: now,
      mtime: now,
    );
    await settingManager.createSetting(setting);
    return setting;
  }
}
