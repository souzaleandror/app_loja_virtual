import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/product_manager.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/screens/address/address_screen.dart';
import 'package:app_loja_virtual/screens/base/base_screen.dart';
import 'package:app_loja_virtual/screens/cart/cart_screen.dart';
import 'package:app_loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:app_loja_virtual/screens/login/login_screen.dart';
import 'package:app_loja_virtual/screens/product/product_screen.dart';
import 'package:app_loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:app_loja_virtual/screens/signup/signup_screen.dart';
import 'package:app_loja_virtual/services/cepaberto_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/admin_users_manager.dart';
import 'models/home_manager.dart';
import 'models/product.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //CEP CERTO
  CepAbertoService()
      .getAddressFromCep('05540-100')
      .then((address) => debugPrint(address.toString()));
  //CEP errado
  CepAbertoService()
      .getAddressFromCep('123123123')
      .then((address) => debugPrint(address.toString()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'Loja Virtual',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 4, 125, 141),
            scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(elevation: 0)),
        home: const BaseScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/base':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/cart':
              return MaterialPageRoute(builder: (_) => const CartScreen());
            case '/address':
              return MaterialPageRoute(builder: (_) => const AddressScreen());
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) =>
                      EditProductScreen(settings.arguments as Product));
            case '/product':
              return MaterialPageRoute(
                  builder: (_) =>
                      ProductScreen(product: settings.arguments as Product));
            case '/select_product':
              return MaterialPageRoute(
                  builder: (_) => const SelectProductScreen());
            default:
              return MaterialPageRoute(builder: (_) => LoginScreen());
          }
        },
      ),
    );
  }
}
