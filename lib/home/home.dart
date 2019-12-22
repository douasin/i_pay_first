import 'package:flutter/material.dart';

import '../ipflib/models.dart';
import '../ipflib/user_manager.dart';
import '../utilities/state_model.dart';

import 'list/list.dart';
import 'menu/menu.dart';
import 'add/add.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements StateWithUpdate {
  UserManager userManager;

  @override
  void initState() {
    super.initState();
    userManager = UserManager(this);
  }

  void _goToAddPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AddTransactionPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: MenuPage(),
      ),
      body: FutureBuilder<List<User>>(
        future: userManager.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Container(child: Text('error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                return UserList(snapshot.data, userManager);
              } else {
                return Center(child: Text('empty...'));
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddPage,
        tooltip: 'Add Txn',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
