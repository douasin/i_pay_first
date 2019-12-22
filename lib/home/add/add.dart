import 'package:flutter/material.dart';

import '../../ipflib/user_manager.dart';
import '../../utilities/state_model.dart';

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({Key key, this.title}) : super(key: key);

  final String title;
  final String balance = '+300';

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    implements StateWithUpdate {
  UserManager userManager;

  @override
  void initState() {
    super.initState();
    userManager = UserManager(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a transaction'),
      ),
      body: Center(child: Text('placeholder')),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
