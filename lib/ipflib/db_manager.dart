import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:i_pay_first/ipflib/models.dart';

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
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String db_path = join(await getDatabasesPath(), 'i_pay_first.db');
    final Future<Database> database = openDatabase(db_path);
    return database;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
      """CREATE TABLE `user_tab`(
            `user_id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
            `name` VARCHAR(255) NOT NULL,
            `balance` BIGINT NOT NULL,
            `order` BIGINT UNSIGNED
        );""",
    );

    await db.execute(
      """CREATE TABLE `balance_history_tab` (
            `history_id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
            `reason` TEXT,
            `ctime` INTEGER UNSIGNED NOT NULL
        );""",
    );

    await db.execute(
      """CREATE TABLE `user_balance_history_tab` (
            `user_id` BIGINT UNSIGNED NOT NULL,
            `history_id` BIGINT UNSIGNED NOT NULL
        );""",
    );
  }

  Future<int> createUser(User user) async {
    final Database dbClient = await db;
    Future<int> res = dbClient.insert("user_tab", user.toMap());

    return res;
  }

  Future<List<User>> getUsers() async {
    final Database dbClient = await db;
    List<Map> results = await dbClient.rawQuery('SELECT * FROM user_tab');
    List<User> user_list = List();
    for (var result in results) {
      User user = User(
        user_id: result['user_id'],
        name: result['name'],
        balance: result['balance'],
        order: result['order'],
      );
      user_list.add(user);
    }

    return user_list;
  }

  Future<int> deleteUserByUserId(int user_id) async {
    final Database dbClient = await db;
    Future<int> res =
        dbClient.rawDelete('DELETE FROM user_tab where id = ?', [user_id]);

    return res;
  }

  Future<bool> updateUser(User user) async {
    final Database dbClient = await db;
    int res = await dbClient.update(
      "user_tab",
      user.toMap(),
      where: "user_id = ?",
      whereArgs: <int>[user.user_id],
    );

    return res > 0;
  }
}
