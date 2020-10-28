import 'package:app_loja_virtual/models/page_manager.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:app_loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:app_loja_virtual/screens/home/home_screen.dart';
import 'package:app_loja_virtual/screens/orders/orders_screen.dart';
import 'package:app_loja_virtual/screens/products/products_screen.dart';
import 'package:app_loja_virtual/screens/stores/stores_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

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
                const StoresScreen(),
                if (userManager.adminEnabled) ...[
                  const AdminUsersScreen(),
                  const AdminOrdersScreen(),
                ]
              ],
            );
          },
        ));
  }
}
