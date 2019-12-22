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

  Transaction({this.transactionId, this.reason, this.ctime});

  Transaction.map(dynamic obj) {
    this.transactionId = obj['transaction_id'];
    this.reason = obj['reason'];
    this.ctime = obj['ctime'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['transaction_id'] = this.transactionId;
    map['reason'] = this.reason;
    map['ctime'] = this.ctime;
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
// class Setting { }
