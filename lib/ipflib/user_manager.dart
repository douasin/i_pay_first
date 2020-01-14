import 'dart:async';

import '../corelib/utils.dart';

import 'db_manager.dart';
import 'models.dart';
import 'constants.dart';

bool isNewUserId(int userId) {
  return userId >= newUserIdStartNumber;
}

bool isNewUser(User user) {
  return isNewUserId(user.userId);
}

class UserManager {
  var dbManager = DatabaseManager();

  UserManager();

  Future<User> getUserByUserId(int userId) async {
    return dbManager.getUserByUserId(userId);
  }

  Future<void> deleteUserByUserId(int userId) async {
    await dbManager.deleteUserByUserId(userId);
  }

  Future<List<User>> getUsers() async {
    return dbManager.getUsers();
  }

  Future<int> getTotalBalance() async {
    List<User> users = await getUsers();
    int total = 0;
    for (var user in users) {
      total += user.balance;
    }
    return total;
  }

  Future<int> createUser(String name, int balance) async {
    int now = getTimestamp();

    Map<String, dynamic> data = {
      'name': name,
      'balance': balance,
      'order': 0,
      'ctime': now,
      'mtime': now,
    };
    return dbManager.createUser(data);
  }

  Future<User> createAndGetUser(String name, int balance) async {
    int userId = await createUser(name, balance);
    return getUserByUserId(userId);
  }

  Future<bool> updateUser(User user) async {
    return dbManager.updateUser(user);
  }
}
