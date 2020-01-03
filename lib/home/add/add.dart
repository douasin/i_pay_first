import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ipflib/user_manager.dart';
import '../../ipflib/models.dart';
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

  bool showTaxFee = false;
  bool showSplit = false;

  final splitAmountController = TextEditingController();
  final payForController = TextEditingController();

  Map<int, bool> splitSelected = {};
  Map<int, TextEditingController> userAmountControllers = {};

  void showOrHideSplit() {
    setState(() {
      showSplit = !showSplit;
      if (showSplit && showTaxFee) {
        showTaxFee = false;
      }
    });
  }

  void showOrHideTaxFee() {
    setState(() {
      showTaxFee = !showTaxFee;
      if (showTaxFee && showSplit) {
        showSplit = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userManager = UserManager(this);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    splitAmountController.dispose();
    super.dispose();
  }

  List<Widget> formList() {
    return <Widget>[
      TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pay For',
          hintText: 'lunch or dinner?',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => payForController.clear(),
          ),
        ),
        controller: payForController,
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 5.0),
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Tax & Fee'),
                    Icon(showTaxFee ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
                onPressed: () => showOrHideTaxFee(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Split Equal'),
                    Icon(showSplit ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
                onPressed: () => showOrHideSplit(),
              ),
            ),
          ),
        ],
      ),
      // split collapse
      showSplit
          ? Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter
                          .digitsOnly, // only numbers can be entered
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pay Amount',
                      hintText: 'the money u pay first',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => splitAmountController.clear(),
                      ),
                    ),
                    controller: splitAmountController,
                  ),
                ),
                SizedBox(width: 5),
                RaisedButton(
                  child: Text('split'),
                  onPressed: () => null,
                ),
              ],
            )
          : Container(),
      // TODO: input box of money, inputbox of tax and service fee (can cache)
      // TODO: share to user has checked by check box, the amount can manually edit by inputbox
    ];
  }

  List<Widget> getUserCheckListByUsers(List<User> users) {
    // TODO: re-order
    users.sort((a, b) => a.order.compareTo(b.order));
    List<User> sortedUsers =
        users.where((user) => splitSelected[user.userId]).toList();
    sortedUsers
        .addAll(users.where((user) => !splitSelected[user.userId]).toList());
    return List<Widget>.generate(sortedUsers.length, (int index) {
      // TODO: checkbox if split toggle on
      var user = sortedUsers[index];
      Widget userRow(user) {
        return Row(children: <Widget>[
          SizedBox(width: 8.0),
          SizedBox(
            width: showSplit ? 120.0 : 180.0,
            child: Text(user.name),
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => userAmountControllers[user.userId].clear(),
                ),
              ),
              controller: userAmountControllers[user.userId],
            ),
          ),
        ]);
      }

      if (showSplit) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: userRow(user),
          value: splitSelected[user.userId],
          onChanged: (bool value) {
            setState(() {
              splitSelected[user.userId] = value;
            });
          },
        );
      } else {
        return ListTile(
          title: userRow(user),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: userManager.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            break;
        }
        if (snapshot.hasError) {
          return Text('error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('empty...');
        }
        var users = snapshot.data;
        for (var user in users) {
          if (!splitSelected.containsKey(user.userId)) {
            splitSelected[user.userId] = false;
          }
          if (!userAmountControllers.containsKey(user.userId)) {
            userAmountControllers[user.userId] = TextEditingController();
          }
        }
        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(formList()),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(getUserCheckListByUsers(users)),
            )
          ],
        );
      },
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
