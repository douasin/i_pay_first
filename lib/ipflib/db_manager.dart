import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:i_pay_firat/ipflib/model.dart';

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
}
