import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:i_pay_first/ipflib/models.dart';

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

  void _goToAddPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add a transaction'),
            ),
            body: Center(child: Text('placeholder')),
          );
        },
      ),
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
        onPressed: _goToAddPage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
