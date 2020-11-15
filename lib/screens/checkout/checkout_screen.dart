import 'package:app_loja_virtual/common/price_card.dart';
import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/checkout_manager.dart';
import 'package:app_loja_virtual/models/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/cpf_field.dart';
import 'components/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CreditCard creditCard = CreditCard();

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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
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
                return Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      CreditCardWidget(
                        creditCard: creditCard,
                      ),
                      const CpfField(),
                      PriceCard(
                        buttonText: 'Finalizar Pedido',
                        onTap: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();

                            checkoutManager.checkout(
                                creditCard: creditCard,
                                onStockFail: (e) {
                                  scaffoldKey.currentState.showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Nao ha estoque suficiente'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  Navigator.of(context).popUntil((route) =>
                                      route.settings.name == '/cart');
                                },
                                onSuccess: (order) {
                                  Navigator.of(context).popUntil(
                                      (route) => route.settings.name == '/');

                                  Navigator.of(context).pushNamed(
                                      '/confirmation',
                                      arguments: order);
                                });
                          }
                        },
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
