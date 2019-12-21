class User {
  int userId;
  String name;
  int balance;
  int order;

  User({this.userId, this.name, this.balance, this.order});

  User.map(dynamic obj) {
    this.userId = obj['user_id'];
    this.name = obj['name'];
    this.balance = obj['balance'];
    this.order = obj['order'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['user_id'] = this.userId;
    map['name'] = this.name;
    map['balance'] = this.balance;
    map['order'] = this.order;
    return map;
  }
}

class Transaction {
  int transactionId;
  String reason;
  int ctime;

  Transaction({this.transactionId, this.reason, this.ctime});
}

class UserTransaction {
  int userId;
  int transactionId;

  UserTransaction({this.userId, this.transactionId});
}
