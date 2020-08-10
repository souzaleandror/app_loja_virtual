import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/screens/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// leco@user.com 123123
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserManager(),
      child: MaterialApp(
        title: 'Loja Virtual',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 4, 125, 141),
            scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(elevation: 0)),
        home: BaseScreen(),
      ),
    );
  }
}
