import 'dart:async';

import '../../corelib/utils.dart';

import '../transaction_manager.dart';
import '../user_manager.dart';
import '../models.dart';
import '../constants.dart';

class TransactionOperator {
  TransactionOperator();

  var transactionManager = TransactionManager();

  Future<Setting> createTransaction(Map<String, dynamic> extraData) async {
    int now = getTimeStamp();
    SettingType type = SettingTypeConfig[settingName];
    setting = Setting(
      settingId: settingId,
      type: SettingTypeNameToValue[type],
      value: formatSettingValueByType(
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
