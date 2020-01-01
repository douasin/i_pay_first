import 'package:flutter/material.dart';

import '../../corelib/price_manager.dart';

import '../../ipflib/models.dart';
import '../../ipflib/user_manager.dart';

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
        '${deflatePrice(user.balance)}',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      trailing: Icon(
        // Icons.mode_edit,
        Icons.more_vert,
        // color: Colors.grey,
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
