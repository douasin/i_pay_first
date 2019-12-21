import 'package:flutter/material.dart';

import '../ipflib/models.dart';
import '../ipflib/user_manager.dart';
import '../utilities/state_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String balance = '+300';

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
      body: FutureBuilder<List<User>>(
        future: userManager.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          /*
          if (snapshot.hasData) {
            return UserList(snapshot.data, userManager);
          } else {
            return Container(child: Text('empty...'));
          }
          */
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                      'state_active: ${ConnectionState.active}, state_none: ${ConnectionState.none}, state_waiting: ${ConnectionState.waiting}'));
            // return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Container(child: Text('error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                return UserList(snapshot.data, userManager);
              } else {
                return Container(child: Text('empty...'));
              }
          }
        },
      ), //_balanceItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddPage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}

class UserList extends StatelessWidget {
  final List<User> userList;
  final UserManager userManager;

  UserList(this.userList, this.userManager, {Key key}) : super(key: key);

  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= userList.length) {
          return null;
        }
        return _buildRow(userList[index]);
      },
    );
  }
}
