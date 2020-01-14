int systemDecimal = 2;

final int newUserIdStartNumber = 10000;

enum SettingType {
  int,
  double,
  string,
  bool,
}

Map<SettingType, int> SettingTypeNameToValue = {
  SettingType.int: 0,
  SettingType.double: 1,
  SettingType.string: 2,
  SettingType.bool: 3,
};
Map<int, SettingType> SettingTypeValueToName = {
  0: SettingType.int,
  1: SettingType.double,
  2: SettingType.string,
  3: SettingType.bool,
};

enum SettingName {
  taxAmount,
  taxActivated,

  feeAmount,
  feeActivated,
}

Map<SettingName, int> SettingNameNameToValue = {
  SettingName.taxAmount: 0,
  SettingName.feeAmount: 1,
  SettingName.taxActivated: 2,
  SettingName.feeActivated: 3,
};
Map<int, SettingName> SettingNameValueToName = {
  0: SettingName.taxAmount,
  1: SettingName.taxActivated,
  2: SettingName.feeAmount,
  3: SettingName.feeActivated,
};

Map<SettingName, SettingType> SettingTypeConfig = {
  SettingName.taxAmount: SettingType.double,
  SettingName.taxActivated: SettingType.bool,
  SettingName.feeAmount: SettingType.double,
  SettingName.feeActivated: SettingType.bool,
};

Map<SettingName, dynamic> SettingDefaultValue = {
  SettingName.taxAmount: 0.0,
  SettingName.taxActivated: false,
  SettingName.feeAmount: 0.0,
  SettingName.feeActivated: false,
};
