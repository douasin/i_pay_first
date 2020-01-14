import 'dart:async';

import '../setting_manager.dart';
import '../models.dart';
import '../constants.dart';

String formatSettingValueByType(dynamic value, SettingType type) {
  if (type == SettingType.string) {
    return value;
  } else if (type == SettingType.double) {
    return value.toStringAsFixed(systemDecimal);
  } else if (type == SettingType.bool) {
    return value.toString();
  }
  // TODO: more type
  return "";
}

dynamic parseSettingValueByType(String value, SettingType type) {
  if (type == SettingType.string) {
    return value;
  } else if (type == SettingType.double) {
    return double.parse(value);
  } else if (type == SettingType.bool) {
    return value.toLowerCase() == 'true';
  }
}

class SettingOperator {
  SettingOperator();
  var settingManager = SettingManager();

  Future<Setting> getOrCreateSettingBySettingName(
      SettingName settingName) async {
    int settingId = SettingNameNameToValue[settingName];
    Setting setting = await settingManager.getSettingBySettingId(settingId);
    if (setting != null) {
      return setting;
    }
    SettingType type = SettingTypeConfig[settingName];
    String value =
        formatSettingValueByType(SettingDefaultValue[settingName], type);
    await settingManager.createSetting(settingId, value);

    return setting;
  }
}
