import 'dart:io';

import 'package:app_loja_virtual/models/page_manager.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:app_loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:app_loja_virtual/screens/home/home_screen.dart';
import 'package:app_loja_virtual/screens/orders/orders_screen.dart';
import 'package:app_loja_virtual/screens/products/products_screen.dart';
import 'package:app_loja_virtual/screens/stores/stores_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
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

    configFCM();
  }

  void configFCM() {
    final fcm = FirebaseMessaging();

    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(
          const IosNotificationSettings(provisional: true));
    }

    fcm.configure(onLaunch: (Map<String, dynamic> message) async {
      debugPrint('onLaunch $message');
    }, onResume: (Map<String, dynamic> message) async {
      debugPrint('onResume $message');
    }, onMessage: (Map<String, dynamic> message) async {
      debugPrint('onMessage $message');
      showNotifications(
        message['notification']['title'] as String,
        message['notification']['body'] as String,
      );
    });
  }

  void showNotifications(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      icon: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    ).show(context);
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
