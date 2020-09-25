import 'package:app_loja_virtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:app_loja_virtual/common/custom_drawer/drawer_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 203, 236, 241), Colors.white]),
            ),
          ),
          ListView(
            children: <Widget>[
              const CustomDrawerHeader(),
              const Divider(),
              // ignore: prefer_const_literals_to_create_immutables
              const DrawerTile(
                iconData: Icons.home,
                title: 'Home',
                page: 0,
              ),
              const Divider(),
              const DrawerTile(
                iconData: Icons.list,
                title: 'Produtos',
                page: 1,
              ),
              const Divider(),
              const DrawerTile(
                iconData: Icons.playlist_add_check,
                title: 'Meus Pedidos',
                page: 2,
              ),
              const Divider(),
              const DrawerTile(
                iconData: Icons.location_on,
                title: 'Lojas',
                page: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
