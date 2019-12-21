import 'dart:async';
// import 'dart:io' as io;

import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DatabaseManager {
  static final DatabaseManager _instance = new DatabaseManager.internal();
  factory DatabaseManager() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseManager.internal();

  initDb() async {
    // io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(await getDatabasesPath(), 'i_pay_first.db');
    final Future<Database> database =
        openDatabase(dbPath, version: 2, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    // BIGINT not supported in sqlite
    // UNSGINED not supported in sqlite
    await db.execute(
      """CREATE TABLE `user_tab`(
            `user_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            `name` VARCHAR(255) NOT NULL,
            `balance` INTEGER NOT NULL,
            `order` INTEGER NOT NULL
        );""",
    );

    await db.execute(
      """CREATE TABLE `balance_history_tab` (
            `history_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            `reason` TEXT,
            `ctime` INTEGER NOT NULL
        );""",
    );

    await db.execute(
      """CREATE TABLE `user_balance_history_tab` (
            `user_id` INTERGER NOT NULL,
            `history_id` INTEGER NOT NULL
        );""",
    );
  }

  Future<int> createUser(User user) async {
    final Database dbClient = await db;
    int res = await dbClient.insert("user_tab", user.toMap());

    return res;
  }

  Future<List<User>> getUsers() async {
    /*
    await deleteUserByUserId(1);
    await deleteUserByUserId(2);
    await deleteUserByUserId(3);
    await deleteUserByUserId(4);
    await createUser(
        User(userId: 1, name: 'Fendy', balance: 3000000, order: 0));
    await createUser(
        User(userId: 2, name: 'Jason', balance: 5000000, order: 0));
    await createUser(User(userId: 3, name: 'Yaru', balance: -45000, order: 0));
    await createUser(User(userId: 4, name: 'Boss', balance: -3000, order: 0));
    */
    print('in get user');
    final Database dbClient = await db;
    List<Map> results = await dbClient.rawQuery('SELECT * FROM user_tab');
    print('results: $results');
    List<User> userList = [];
    for (var result in results) {
      User user = User(
        userId: result['user_id'],
        name: result['name'],
        balance: result['balance'],
        order: result['order'],
      );
      userList.add(user);
    }

    return userList;
  }

  Future<int> deleteUserByUserId(int userId) async {
    final Database dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM user_tab where user_id = ?', [userId]);

    return res;
  }

  Future<bool> updateUser(User user) async {
    final Database dbClient = await db;
    int res = await dbClient.update(
      "user_tab",
      user.toMap(),
      where: "user_id = ?",
      whereArgs: <int>[user.userId],
    );

    return res > 0;
  }
}
