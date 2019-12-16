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

class BalanceHistory {
  final int history_id;
  final String reason;
  final int created_at;

  BalanceHistory({this.history_id, this.reason, this.created_at});
}

class UserBalanceHistory {
  final int user_id;
  final int history_id;

  UserBalanceHistory({this.user_id, this.history_id});
}
