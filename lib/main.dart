import 'package:flutter/material.dart';

import 'package:i_pay_first/home.dart';

// TODO: oauth2
// TODO: plus nevigator
// TODO: db
// TODO: tutorial for newbie

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
