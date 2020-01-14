import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../corelib/price_manager.dart';

import '../../ipflib/user_manager.dart';
import '../../ipflib/models.dart';
import '../../ipflib/constants.dart';
import '../../ipflib/operators/transaction_operator.dart';
import '../../ipflib/operators/setting_operator.dart';
import '../../utilities/formatter.dart';

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({Key key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  UserManager userManager;

  @override
  void initState() {
    super.initState();
    userManager = UserManager();
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

class _AddTransactionListState extends State<AddTransactionList> {
  UserManager userManager;
  SettingOperator settingOperator;
  TransactionOperator transactionOperator;

  bool initCompleted = false;
  bool showTaxFee = false;
  bool showSplit = false;

  bool useTax = false;
  bool useFee = false;
  Timer setStateOngoing;
  Queue<Function> setStateQueue = Queue();

  final splitAmountController = TextEditingController();
  final payForController = TextEditingController();

  final taxAmountController = TextEditingController();
  final feeAmountController = TextEditingController();

  Map<int, bool> splitSelectedUsers = {};
  Map<int, TextEditingController> userAmountControllers = {};
  Map<int, TextEditingController> newUserNameControllers = {};
  Map<int, User> userCache = {};

  List<User> newUserList = [];

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

  void delaySetState(Function function) {
    const duration = Duration(milliseconds: 800);
    if (setStateOngoing != null) {
      setStateOngoing.cancel();
    }
    setStateQueue.add(function);
    setStateOngoing = Timer(duration, () {
      setState(() {
        while (setStateQueue.isNotEmpty) {
          Function func = setStateQueue.removeLast();
          func();
        }
      });
    });
  }

  String getCurrentBalanceByUser(User user) {
    String currentBalanceString = userAmountControllers[user.userId].text;
    if (currentBalanceString.isEmpty) {
      return "";
    }
    double currentBalanceByUser = double.parse(currentBalanceString);
    String result = "${currentBalanceByUser.toStringAsFixed(systemDecimal)}";
    double rate = 1.0;

    String taxAmountString = taxAmountController.text;
    double taxAmount = 0.0;
    if (useTax && taxAmountString.isNotEmpty) {
      taxAmount = double.parse(taxAmountString);
      rate += (taxAmount / 100);
    }

    String feeAmountString = feeAmountController.text;
    double feeAmount = 0.0;
    if (useFee && feeAmountString.isNotEmpty) {
      feeAmount = double.parse(feeAmountString);
      rate += (feeAmount / 100);
    }

    if ((useTax && taxAmountString.isNotEmpty) ||
        (useFee && feeAmountString.isNotEmpty)) {
      String useTaxString = useTax
          ? "${taxAmount >= 0 ? '+' : '-'} ${(taxAmount / 100).toStringAsFixed(systemDecimal)}"
          : "";
      String useFeeString = useFee
          ? "${feeAmount >= 0 ? '+' : '-'} ${(feeAmount / 100).toStringAsFixed(systemDecimal)}"
          : "";
      double totalAmount = currentBalanceByUser * rate;
      String template =
          " * (1 ${useTaxString} ${useFeeString}) = ${totalAmount.toStringAsFixed(systemDecimal)}";
      result += template;
    }
    return result;
  }

  bool canSplitToSelectedUsers() {
    if (splitAmountController.text.isEmpty) {
      return false;
    }
    Iterable<int> selectedUserIds =
        splitSelectedUsers.keys.where((userId) => splitSelectedUsers[userId]);
    int numberNeedToSplit = selectedUserIds.length;
    if (numberNeedToSplit == 0) {
      return false;
    }
    return true;
  }

  void splitToSelectedUsers() {
    if (!canSplitToSelectedUsers()) {
      return;
    }
    Iterable<int> selectedUserIds =
        splitSelectedUsers.keys.where((userId) => splitSelectedUsers[userId]);
    int numberNeedToSplit = selectedUserIds.length;
    double splitAmount =
        double.parse(splitAmountController.text) / numberNeedToSplit;
    for (var userId in selectedUserIds) {
      var userAmountController = userAmountControllers[userId];
      userAmountController.text = splitAmount.toStringAsFixed(systemDecimal);
    }
    // collapse after split
    showOrHideSplit();
  }

  bool hasEmptyNewUser() {
    for (var user in newUserList) {
      if (user.name.isEmpty) {
        return true;
      }
    }
    return false;
  }

  void initialUserServiceByUser(User user) {
    splitSelectedUsers[user.userId] = false;
    userAmountControllers[user.userId] = TextEditingController();
    userCache[user.userId] = user;
    if (isNewUserId(user.userId)) {
      if (newUserNameControllers.containsKey(user.userId)) {
        return;
      }
      newUserNameControllers[user.userId] = TextEditingController();
    }
  }

  Function addContact() {
    if (hasEmptyNewUser()) {
      return null;
    }
    void _addContact() {
      setState(() {
        int newUserId = newUserIdStartNumber + newUserList.length;
        User newUser = User(
            userId: newUserId,
            name: "",
            balance: 0,
            order: 0,
            ctime: 0,
            mtime: 0);
        initialUserServiceByUser(newUser);
        newUserList.add(newUser);
      });
    }

    return _addContact;
  }

  void showStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Widget> transactionDetail = [];
        String taxAmountString = taxAmountController.text;
        String feeAmountString = feeAmountController.text;
        double rate = 1.0;
        double totalAmount = 0.0;
        if (useTax && taxAmountString.isNotEmpty) {
          double taxAmount = double.parse(taxAmountString);
          rate += taxAmount / 100;
          transactionDetail
              .add(Text('tax: ${taxAmount.toStringAsFixed(systemDecimal)}'));
        }
        if (useFee && feeAmountString.isNotEmpty) {
          double feeAmount = double.parse(feeAmountString);
          rate += feeAmount / 100;
          transactionDetail
              .add(Text('fee: ${feeAmount.toStringAsFixed(systemDecimal)}'));
        }
        if (useTax && taxAmountString.isNotEmpty ||
            useFee && feeAmountString.isNotEmpty) {
          transactionDetail.add(
            Divider(),
          );
        }
        for (var userId in userAmountControllers.keys) {
          var userAmountController = userAmountControllers[userId];
          if (userAmountController.text.isEmpty) {
            continue;
          }
          var user = userCache[userId];
          double userAmount = double.parse(userAmountController.text);
          totalAmount += userAmount * rate;
          transactionDetail.add(
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${user.name}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text:
                          '${(userAmount * rate).toStringAsFixed(systemDecimal)}'),
                ],
              ),
            ),
          );
        }
        transactionDetail.add(Divider());
        transactionDetail
            .add(Text('total: ${totalAmount.toStringAsFixed(systemDecimal)}'));
        return AlertDialog(
          title: Text("You pay first for ${payForController.text}"),
          content: SingleChildScrollView(
            child: ListBody(
              children: transactionDetail,
            ),
          ),
          actions: <Widget>[
            FlatButton(
                color: Colors.green,
                child: Text('Pay'),
                onPressed: () {
                  createTransaction();
                  // Pop two times to main menu.
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<void> createTransaction() async {
    String payReason = payForController.text;
    Map<String, dynamic> extraData = {};

    double rate = 1.0;
    int totalAmount = 0;

    String taxAmountString = taxAmountController.text;
    if (useTax && taxAmountString.isNotEmpty) {
      double taxAmount = double.parse(taxAmountString);
      rate += taxAmount / 100;
      extraData['tax'] = taxAmount;
    }
    String feeAmountString = feeAmountController.text;
    if (useFee && feeAmountString.isNotEmpty) {
      double feeAmount = double.parse(feeAmountString);
      rate += feeAmount / 100;
      extraData['fee'] = feeAmount;
    }
    extraData['rate'] = rate;

    List<User> usersHaveAmount = [];
    Map<int, int> userBalanceMap = {};
    for (var userId in userAmountControllers.keys) {
      var userAmountController = userAmountControllers[userId];
      if (userAmountController.text.isEmpty) {
        continue;
      }
      var user = userCache[userId];
      int userAmount = inflatePrice(userAmountController.text);
      int userActualAmount = (userAmount.toDouble() * rate).round();

      usersHaveAmount.add(user);
      userBalanceMap[user.userId] = userActualAmount;
      totalAmount += userActualAmount;
    }
    extraData['total_amount'] = totalAmount;

    await transactionOperator.createTransaction(
        payReason, usersHaveAmount, userBalanceMap, extraData);
  }

  bool canCreateTransaction() {
    if (payForController.text.isEmpty) {
      return false;
    }
    for (var newUser in newUserList) {
      if (newUser.name.isEmpty &&
          userAmountControllers[newUser.userId].text.isNotEmpty) {
        return false;
      }
    }
    bool hasRecord = false;
    for (var userAmountController in userAmountControllers.values) {
      if (userAmountController.text.isNotEmpty) {
        hasRecord = true;
        break;
      }
    }
    return hasRecord;
  }

  Function createTransactionModal() {
    if (!canCreateTransaction()) {
      return null;
    }
    return showStatus;
  }

  @override
  void initState() {
    super.initState();
    userManager = UserManager();
    settingOperator = SettingOperator();
    transactionOperator = TransactionOperator();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (var userAmountController in userAmountControllers.values) {
      userAmountController.dispose();
    }
    for (var newUserNameController in newUserNameControllers.values) {
      newUserNameController.dispose();
    }
    splitAmountController.dispose();
    payForController.dispose();
    taxAmountController.dispose();
    feeAmountController.dispose();
    super.dispose();
  }

  List<Widget> formList() {
    return <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Add'),
                      Icon(Icons.contacts),
                    ],
                  ),
                  onPressed: addContact(),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Expanded(
            child: RaisedButton(
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Pay'),
                  Icon(Icons.monetization_on),
                ],
              ),
              onPressed: createTransactionModal(),
            ),
          ),
        ],
      ),
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
        onChanged: (val) {
          delaySetState(() => null);
        },
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      DecimalTextInputFormatter(decimalRange: 2),
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
                  onPressed: canSplitToSelectedUsers()
                      ? () => splitToSelectedUsers()
                      : null,
                ),
              ],
            )
          : Container(),
      // tax collapse
      showTaxFee
          ? Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: useTax,
                        onChanged: (bool value) {
                          setState(() {
                            useTax = value;
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            DecimalTextInputFormatter(decimalRange: 2),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tax',
                            hintText: '',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => taxAmountController.clear(),
                            ),
                          ),
                          controller: taxAmountController,
                          onChanged: (val) {
                            if (useTax) {
                              delaySetState(() => null);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: useFee,
                        onChanged: (bool value) {
                          setState(() {
                            useFee = value;
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Fee',
                            hintText: '%',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => feeAmountController.clear(),
                            ),
                          ),
                          controller: feeAmountController,
                          onChanged: (val) {
                            if (useFee) {
                              delaySetState(() => null);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
    ];
  }

  Widget userNameOrTextField(User user) {
    if (!isNewUser(user)) {
      return Text(user.name);
    } else {
      return TextFormField(
          controller: newUserNameControllers[user.userId],
          onChanged: (val) {
            delaySetState(() {
              user.name = val;
            });
          });
    }
  }

  List<Widget> getUserCheckListByUsers(List<User> users) {
    users.sort((a, b) => a.order.compareTo(b.order));
    List<User> sortedUsers = [
      ...newUserList,
      ...users.where((user) => splitSelectedUsers[user.userId]).toList(),
      ...users.where((user) => !splitSelectedUsers[user.userId]).toList(),
    ];
    return List<Widget>.generate(sortedUsers.length, (int index) {
      var user = sortedUsers[index];

      Widget userRow(user) {
        return Row(children: <Widget>[
          SizedBox(width: 8.0),
          Expanded(child: userNameOrTextField(user)),
          SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                DecimalTextInputFormatter(decimalRange: 2),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => delaySetState(
                      () => userAmountControllers[user.userId].clear()),
                ),
              ),
              controller: userAmountControllers[user.userId],
              onChanged: (val) {
                delaySetState(() => null);
              },
            ),
          ),
        ]);
      }

      Widget userSubtitle(User user) {
        if (useTax == true || useFee == true) {
          return Row(children: <Widget>[
            SizedBox(width: 8.0),
            Expanded(child: Text(getCurrentBalanceByUser(user))),
            Expanded(child: Container()),
          ]);
        } else {
          return Container();
        }
      }

      if (showSplit) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: userRow(user),
          value: splitSelectedUsers[user.userId],
          onChanged: (bool value) {
            setState(() {
              splitSelectedUsers[user.userId] = value;
            });
          },
          subtitle: userSubtitle(user),
        );
      } else {
        return ListTile(
          title: userRow(user),
          subtitle: userSubtitle(user),
        );
      }
    });
  }

  Future<Map<String, dynamic>> getUsersAndSettings() async {
    Map<String, dynamic> result = {
      'users': await userManager.getUsers(),
      'tax_amount': await settingOperator
          .getOrCreateSettingBySettingName(SettingName.taxAmount),
      'tax_activated': await settingOperator
          .getOrCreateSettingBySettingName(SettingName.taxActivated),
      'fee_amount': await settingOperator
          .getOrCreateSettingBySettingName(SettingName.feeAmount),
      'fee_activated': await settingOperator
          .getOrCreateSettingBySettingName(SettingName.feeActivated),
    };
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUsersAndSettings(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
        var users = snapshot.data['users'];
        if (!initCompleted) {
          for (var user in users) {
            initialUserServiceByUser(user);
          }
          taxAmountController.text = snapshot.data['tax_amount'].value;
          feeAmountController.text = snapshot.data['fee_amount'].value;
          useTax = parseSettingValueByType(
            snapshot.data['tax_activated'].value,
            SettingTypeValueToName[snapshot.data['tax_activated'].type],
          );
          useFee = parseSettingValueByType(
            snapshot.data['fee_activated'].value,
            SettingTypeValueToName[snapshot.data['fee_activated'].type],
          );
          initCompleted = true;
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
}
