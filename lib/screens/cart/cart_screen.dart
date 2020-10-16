import 'package:app_loja_virtual/common/empty_card.dart';
import 'package:app_loja_virtual/common/login_card.dart';
import 'package:app_loja_virtual/common/price_card.dart';
import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/screens/cart/components/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(builder: (_, cartManager, __) {
        debugPrint(cartManager.isCartValid.toString());
        if (cartManager.user == null) {
          return const LoginCard();
        }

        if (cartManager.items.isEmpty) {
          return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho');
        }

        return ListView(
          children: [
            Column(
              children: cartManager.items
                  .map(
                    (cartManager) => CartTile(cartProduct: cartManager),
                  )
                  .toList(),
            ),
            PriceCard(
              buttonText: 'Continuar para o endereco',
              onTap: cartManager.isCartValid
                  ? () {
                      Navigator.of(context).pushNamed('/address');
                    }
                  : null,
            ),
          ],
        );
      }),
    );
  }
}
