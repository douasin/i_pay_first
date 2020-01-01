import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ipflib/user_manager.dart';
import '../../utilities/state_model.dart';

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({Key key}) : super(key: key);

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
      body: AddTransactionList(),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}

class AddTransactionList extends StatefulWidget {
  AddTransactionList({Key key}) : super(key: key);

  @override
  _AddTransactionListState createState() => _AddTransactionListState();
}

class _AddTransactionListState extends State<AddTransactionList>
    implements StateWithUpdate {
  UserManager userManager;
  // Settings Manager

  @override
  void initState() {
    super.initState();
    userManager = UserManager(this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Pay For',
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 5.0),
                child: RaisedButton(
                  child: Text('Tax'),
                  onPressed: () => null,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                child: RaisedButton(
                  child: Text('Split Equal'),
                  onPressed: () => null,
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter
                .digitsOnly, // only numbers can be entered
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Pay Amount',
          ),
        ),
        // TODO: input box of money, inputbox of tax and service fee (can cache)
        // TODO: share button
        // TODO: share to user has checked by check box, the amount can manually edit by inputbox
      ],
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
