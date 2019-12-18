class User {
  int user_id;
  String name;
  double balance;
  int order;

  User({this.user_id, this.name, this.balance, this.order});

  User.map(dynamic obj) {
    this.user_id = obj['user_id'];
    this.name = obj['name'];
    this.balance = obj['balance'];
    this.order = obj['order'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['user_id'] = this.user_id;
    map['name'] = this.name;
    map['balance'] = this.balance;
    map['order'] = this.order;
  }
}

class Transaction {
  int transaction_id;
  String reason;
  int ctime;

  Transaction({this.transaction_id, this.reason, this.ctime});
}

class UserTransaction {
  int user_id;
  int transaction_id;

  UserTransaction({this.user_id, this.transaction_id});
}
