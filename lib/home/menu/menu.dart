import 'package:flutter/material.dart';

import '../../corelib/price_manager.dart';

import '../../ipflib/user_manager.dart';

import '../../utilities/state_model.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> implements StateWithUpdate {
  UserManager userManager;

  @override
  void initState() {
    super.initState();
    userManager = UserManager(this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 28,
                  ),
                  child: FutureBuilder<int>(
                    future: userManager.getTotalBalance(),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('error: ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                            var balance = snapshot.data;
                            Color balanceColor = Colors.white;
                            String balanceString = '${deflatePrice(balance)}';
                            if (balance > 0) {
                              balanceColor = Colors.red;
                              balanceString = '+$balanceString';
                            } else if (balance < 0) {
                              balanceColor = Colors.green;
                            }
                            return RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Balance: '),
                                  TextSpan(
                                    text: balanceString,
                                    style: TextStyle(
                                      color: balanceColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Text('empty...');
                          }
                      }
                      return Container();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('history'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('settings'),
        ),
      ],
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
