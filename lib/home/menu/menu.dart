import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
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
}
