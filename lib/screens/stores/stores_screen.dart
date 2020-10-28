import 'package:app_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:app_loja_virtual/models/stores_manager.dart';
import 'package:app_loja_virtual/screens/stores/components/store_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Stores'),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __) {
          if (storesManager.stores.isEmpty) {
            return const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }

          return ListView.builder(
            itemCount: storesManager.stores.length,
            itemBuilder: (_, index) {
              return StoreCard(store: storesManager.stores[index]);
            },
          );
        },
      ),
    );
  }
}
