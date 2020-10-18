import 'package:app_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:app_loja_virtual/models/page_manager.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:app_loja_virtual/screens/home/home_screen.dart';
import 'package:app_loja_virtual/screens/orders/orders_screen.dart';
import 'package:app_loja_virtual/screens/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<int> inteiros = [
      1,
      2,
      3,
      4,
      ...[5, 6],
      //if (false) ...[7, 8],
      if (true) ...[9, 10],
    ];

    debugPrint(inteiros.toString());

    return Provider(
        create: (_) => PageManager(pageController),
        child: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                const HomeScreen(),
                const ProductsScreen(),
                const OrdersScreen(),
                Scaffold(
                  drawer: const CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Home4'),
                  ),
                ),
                if (userManager.adminEnabled) ...[
                  const AdminUsersScreen(),
                  Scaffold(
                    drawer: const CustomDrawer(),
                    appBar: AppBar(
                      title: const Text('Pedidos'),
                    ),
                  ),
                ]
              ],
            );
          },
        ));
  }
}
