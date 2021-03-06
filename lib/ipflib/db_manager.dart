import 'dart:async';
// import 'dart:io' as io;

import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'models.dart';

class DatabaseManager {
  static final DatabaseManager _instance = new DatabaseManager.internal();
  factory DatabaseManager() => _instance;
  static sqflite.Database _db;

  Future<sqflite.Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseManager.internal();

  initDb() async {
    // io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(await sqflite.getDatabasesPath(), 'i_pay_first.db');
    final Future<sqflite.Database> database = sqflite.openDatabase(
      dbPath,
      version: 8,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  void _onCreate(sqflite.Database db, int version) async {
    // When creating the db, create the table
    // BIGINT not supported in sqlite
    // UNSGINED not supported in sqlite
    await db.execute(
      """CREATE TABLE `user_tab`(
            `user_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            `name` VARCHAR(255) NOT NULL,
            `balance` INTEGER NOT NULL,
            `order` INTEGER NOT NULL,
            `ctime` INTEGER NOT NULL,
            `mtime` INTEGER NOT NULL
        );""",
    );

    await db.execute(
      """CREATE TABLE `transaction_tab` (
            `transaction_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            `reason` TEXT,
            `ctime` INTEGER NOT NULL,
            `mtime` INTEGER NOT NULL,
	    `extra_data` TEXT NOT NULL
        );""",
    );

    await db.execute(
      """CREATE TABLE `user_transaction_tab` (
            `user_id` INTERGER NOT NULL,
            `transaction_id` INTEGER NOT NULL
        );""",
    );

    await db.execute(
      """CREATE TABLE `setting_tab` (
	    `setting_id` INTEGER NOT NULL,
	    `type` INTEGER NOT NULL,
	    `value` TEXT NOT NULL,
	    `ctime` INTEGER NOT NULL,
	    `mtime` INTEGER NOT NULL
	);""",
    );
  }

  void _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS user_tab");
    await db.execute("DROP TABLE IF EXISTS transaction_tab");
    await db.execute("DROP TABLE IF EXISTS user_transaction_tab");
    await db.execute("DROP TABLE IF EXISTS setting_tab");
    _onCreate(db, newVersion);
  }

  Future<int> createUser(Map<String, dynamic> data) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient.insert("user_tab", data);

    return res;
  }

  Future<User> getUserByUserId(int userId) async {
    final sqflite.Database dbClient = await db;
    List<Map> results = await dbClient.query(
      "user_tab",
      columns: null, // all columns
      where: "user_id = ?",
      whereArgs: <int>[userId],
    );
    if (results.isEmpty) {
      return null;
    }
    var result = results[0];

    User user = User(
      userId: result['user_id'],
      name: result['name'],
      balance: result['balance'],
      order: result['order'],
      ctime: result['ctime'],
      mtime: result['mtime'],
    );

    return user;
  }

  Future<List<User>> getUsers() async {
    /*
    // TEST DATA
    await deleteUserByUserId(1);
    await deleteUserByUserId(2);
    await deleteUserByUserId(3);
    await deleteUserByUserId(4);
    await createUser(User(
        userId: 1,
        name: 'Fendy',
        balance: 3000000,
        order: 0,
        ctime: 0,
        mtime: 0));
    await createUser(User(
        userId: 2,
        name: 'Jason',
        balance: 5000000,
        order: 0,
        ctime: 0,
        mtime: 0));
    await createUser(User(
        userId: 3,
        name: 'Yaru',
        balance: -45000,
        order: 0,
        ctime: 0,
        mtime: 0));
    await createUser(User(
        userId: 4, name: 'Boss', balance: -3000, order: 0, ctime: 0, mtime: 0));
	*/
    final sqflite.Database dbClient = await db;
    List<Map> results = await dbClient.rawQuery('SELECT * FROM user_tab');
    List<User> userList = [];
    for (var result in results) {
      User user = User(
        userId: result['user_id'],
        name: result['name'],
        balance: result['balance'],
        order: result['order'],
        ctime: result['ctime'],
        mtime: result['mtime'],
      );
      userList.add(user);
    }

    return userList;
  }

  Future<int> deleteUserByUserId(int userId) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM user_tab where user_id = ?', [userId]);

    return res;
  }

  Future<bool> updateUser(User user) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient.update(
      "user_tab",
      user.toMap(),
      where: "user_id = ?",
      whereArgs: <int>[user.userId],
    );

    return res > 0;
  }

  Future<int> createTransaction(Map<String, dynamic> data) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient.insert("transaction_tab", data);

    return res;
  }

  Future<int> createUserTransaction(Map<String, dynamic> data) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient.insert("user_transaction_tab", data);

    return res;
  }

  Future<Setting> getSettingBySettingId(int settingId) async {
    final sqflite.Database dbClient = await db;
    List<Map> results = await dbClient.query(
      "setting_tab",
      columns: null, // all columns
      where: "setting_id = ?",
      whereArgs: <int>[settingId],
    );
    if (results.isEmpty) {
      return null;
    }
    var result = results[0];

    Setting setting = Setting(
      settingId: result['setting_id'],
      type: result['type'],
      value: result['value'],
      ctime: result['ctime'],
      mtime: result['mtime'],
    );

    return setting;
  }

  Future<int> createSetting(Map<String, dynamic> data) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient.insert("setting_tab", data);

    return res;
  }

  Future<bool> updateSetting(Setting setting) async {
    final sqflite.Database dbClient = await db;
    int res = await dbClient.update(
      "setting_tab",
      setting.toMap(),
      where: "setting_id = ?",
      whereArgs: <int>[setting.settingId],
    );

    return res > 0;
  }
}
