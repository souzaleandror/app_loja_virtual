import 'package:app_loja_virtual/common/price_card.dart';
import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/checkout_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    Text(
                      'Processando seu pagamento..',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return ListView(
                children: [
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onTap: () {
                      checkoutManager.checkout(onStockFail: (e) {
                        scaffoldKey.currentState.showSnackBar(
                          const SnackBar(
                            content: Text('Nao ha estoque suficiente'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == '/cart');
                      }, onSuccess: (order) {
                        Navigator.of(context)
                            .popUntil((route) => route.settings.name == '/');

                        Navigator.of(context)
                            .pushNamed('/confirmation', arguments: order);
                      });
                    },
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
