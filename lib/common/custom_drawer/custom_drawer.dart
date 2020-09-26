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
            children: const <Widget>[
              CustomDrawerHeader(),
              Divider(),
              DrawerTile(
                iconData: Icons.home,
                title: 'Home',
                page: 0,
              ),
              Divider(),
              DrawerTile(
                iconData: Icons.list,
                title: 'Produtos',
                page: 1,
              ),
              Divider(),
              DrawerTile(
                iconData: Icons.playlist_add_check,
                title: 'Meus Pedidos',
                page: 2,
              ),
              Divider(),
              DrawerTile(
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
