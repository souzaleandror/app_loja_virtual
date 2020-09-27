import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:app_loja_virtual/models/admin_users_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('Usuarios'),
          centerTitle: true,
        ),
        body: Consumer<AdminUsersManager>(
          builder: (_, adminUserManager, __) {
            return AlphabetListScrollView(
              itemBuilder: (_, index) {
                print(adminUserManager.users[index].admin);
                return ListTile(
                  title: Text(
                    adminUserManager.users[index].name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: Row(
                    children: [
                      Text(adminUserManager.users[index].email,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                      if (adminUserManager.users[index].admin == true)
                        const Text("*",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300)),
                    ],
                  ),
                );
              },
              indexedHeight: (index) => 80,
              strList: adminUserManager.names,
              showPreview: true,
              normalTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 12),
              highlightTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 20),
            );
          },
        ));
  }
}
