import 'package:flutter/material.dart';

import 'home/home.dart';

// TODO: oauth2 -> xxx -> save to googledrive?
// TODO: tutorial for newbie
// TODO: editor info
// TODO: clean balance button

void main() => runApp(MyApp());

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
