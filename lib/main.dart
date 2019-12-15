import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int user_id;
  final String name;
  final double balance;
  final int order;

  User({this.user_id, this.name, this.balance, this.order});
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

// TODO: oauth2
// TODO: plus nevigator
// TODO: db
// TODO: tutorial for newbie

void main() => runApp(MyApp());

class UserBalance {
  final String name;

  const UserBalance({this.name});
}

class MyApp extends StatelessWidget {
  final String title = 'I Pay First';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String balance = '+300';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  Widget _menuItems() {
    return ListView(
      padding: EdgeInsets.zero,
      children: const <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('history'),
        ),
      ],
    );
  }

  Widget _buildRow(User user) {
    return ListTile(
      title: Text(
        user.name,
        style: _biggerFont,
      ),
      subtitle: Text(
        '${user.balance}',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      trailing: Icon(
        Icons.mode_edit,
        color: Colors.grey,
      ),
    );
  }

  // TODO: load from db
  final List<User> user_list = [
    User(user_id: 1, name: 'Fendy', balance: 30, order: 0),
    User(user_id: 2, name: 'Jason', balance: 50, order: 0),
    User(user_id: 3, name: 'Yaru', balance: -4.5, order: 0),
    User(user_id: 4, name: 'Boss', balance: -30, order: 0),
  ];

  Widget _balanceItems() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= user_list.length) {
          return null;
        }
        return _buildRow(user_list[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ' ' + widget.balance),
      ),
      drawer: Drawer(
        child: _menuItems(),
      ),
      body: _balanceItems(),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
