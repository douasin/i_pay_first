int systemDecimal = 2;

enum SettingType {
  int,
  double,
  string,
}

Map<SettingType, int> SettingTypeNameToValue = {
  SettingType.int: 0,
  SettingType.double: 1,
  SettingType.string: 2,
};
Map<int, SettingType> SettingTypeValueToName = {
  0: SettingType.int,
  1: SettingType.double,
  2: SettingType.string,
};

enum SettingName {
  tax,
  fee,
}

Map<SettingName, int> SettingNameNameToValue = {
  SettingName.tax: 0,
  SettingName.fee: 1,
};
Map<int, SettingName> SettingNameValueToName = {
  0: SettingName.tax,
  1: SettingName.fee,
};

Map<SettingName, SettingType> SettingTypeConfig = {
  SettingName.tax: SettingType.double,
  SettingName.fee: SettingType.double,
};

Map<SettingName, dynamic> SettingDefaultValue = {
  SettingName.tax: 0.0,
  SettingName.fee: 0.0,
};
