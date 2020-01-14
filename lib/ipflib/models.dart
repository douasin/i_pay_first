// User & Transaction
class User {
  int userId;
  String name;
  int balance;
  int order;
  int ctime;
  int mtime;

  User(
      {this.userId,
      this.name,
      this.balance,
      this.order,
      this.ctime,
      this.mtime});

  User.map(dynamic obj) {
    this.userId = obj['user_id'];
    this.name = obj['name'];
    this.balance = obj['balance'];
    this.order = obj['order'];
    this.ctime = obj['ctime'];
    this.mtime = obj['mtme'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['user_id'] = this.userId;
    map['name'] = this.name;
    map['balance'] = this.balance;
    map['order'] = this.order;
    map['ctime'] = this.ctime;
    map['mtime'] = this.mtime;
    return map;
  }
}

class Transaction {
  int transactionId;
  String reason;
  int ctime;
  int mtime;
  String extraData;

  Transaction(
      {this.transactionId,
      this.reason,
      this.ctime,
      this.mtime,
      this.extraData});

  Transaction.map(dynamic obj) {
    this.transactionId = obj['transaction_id'];
    this.reason = obj['reason'];
    this.ctime = obj['ctime'];
    this.mtime = obj['mtime'];
    this.extraData = obj['extra_data'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['transaction_id'] = this.transactionId;
    map['reason'] = this.reason;
    map['ctime'] = this.ctime;
    map['mtime'] = this.mtime;
    map['extra_data'] = this.extraData;
    return map;
  }
}

class UserTransaction {
  int userId;
  int transactionId;

  UserTransaction({this.userId, this.transactionId});

  UserTransaction.map(dynamic obj) {
    this.userId = obj['usreId'];
    this.transactionId = obj['transactionId'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['user_id'] = this.userId;
    map['transaction_id'] = this.transactionId;
    return map;
  }
}

// Settings
class Setting {
  int settingId;
  int type;
  String value;
  int ctime;
  int mtime;

  Setting({this.settingId, this.type, this.value, this.ctime, this.mtime});

  Setting.map(dynamic obj) {
    this.settingId = obj['setting_id'];
    this.type = obj['type'];
    this.value = obj['value'];
    this.ctime = obj['ctime'];
    this.mtime = obj['mtime'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['setting_id'] = this.settingId;
    map['type'] = this.type;
    map['value'] = this.value;
    map['ctime'] = this.ctime;
    map['mtime'] = this.mtime;
    return map;
  }
}
