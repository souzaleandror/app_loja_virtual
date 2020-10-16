import 'package:app_loja_virtual/models/order.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cart_manager.dart';

class CheckoutManager extends ChangeNotifier {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
    debugPrint(cartManager.productsPrice.toString());
  }

  Future<void> checkout({Function onStockFail, Function onSuccess}) async {
    loading = true;
    try {
      _decrementStock();
    } catch (e, ex) {
      onStockFail(e);
      debugPrint("$e >>> $ex");
      loading = false;
      return;
    }

    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();

    await order.save();
    cartManager.clear();

    //_getOrderId().then((value) => debugPrint(value.toString()));
    loading = false;
  }

  // TODO: PROCESSAR O PAGAMENTO

  Future<int> _getOrderId() async {
    final ref = _firebase.doc('aux/ordercounter');

    try {
      //NUNCA USAR COMANDOS GET OU SNAPSHOTS DENTRO DE UMA TRANSACTION PORQUE VAI TRAVAR TODO O BANCO
      final result = await _firebase.runTransaction((transaction) async {
        final doc = await transaction.get(ref);
        final orderId = doc.data()['current'] as int;
        transaction.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      }, timeout: const Duration(seconds: 10));
      return result['orderId'];
    } catch (e, ex) {
      debugPrint("$e >>> $ex");
      return Future.error('Falha ao gerar numero do pedido');
    }
  }

  Future<void> _decrementStock() async {
    _firebase.runTransaction((transaction) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.id)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await transaction
              .get(_firebase.doc('products/${cartProduct.productId}'));

          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);
        if (size.stock - cartProduct.quantity < 0) {
          //FALHAR
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }

        if (productsWithoutStock.isNotEmpty) {
          return Future.error(
              '${productsWithoutStock.length} produtos sem estoque');
        }

        for (final product in productsToUpdate) {
          transaction.update(_firebase.doc('products/${product.id}'),
              {'sizes': product.exportSizeList()});
        }
      }
    });

    //  1.  Ler todos os estoques
    //  2.  Decremento localmente os estoques
    //  3.  Salvar os estoques no firebase

    // LOGICA CERTA - EXEMPLO 2
    // CART ITEMS
    // Branca 5xM 2xGG  5 M
    // Branca 5xM 2xGG  2 GG
    // Preta  1xP       1 P

    // PRODUCTS TO UPDATE
    // Branca 5xM 2xGG  5 M
    // Preta  1xP       1 P

    // DECREMENT
    // Branca 0xM 0xGG
    // Preta  0xP

    // **
    // LOGICA CERTA - EXEMPLO 1
    // CART ITEMS
    // Branca 5xM 2xGG  5 M
    // Branca 5xM 2xGG  2 GG
    // Preta  1xP       1 P

    // PRODUCTS TO UPDATE
    // Branca 5xM 2xGG  5 M
    // Preta  1xP       1 P

    // DECREMENT
    // Branca 0xM 0xGG
    // Preta  0xP

    //**
    // ERRADO LOGICA
    // CART ITEMS
    // Branca 5xM 2xGG  5 M
    // Branca 5xM 2xGG  2 GG
    // Preta  1xP       1 P

    // PRODUCTS TO UPDATE
    // Branca 5xM 2xGG
    // Branca 5xM 2xGG
    // Preta  1xP

    // DECREMENT
    // Branca 0xM 2xGG
    // Branca 5xM 0xGG
    // Preta  0xP

    // ESCREVER NO FIREBASE
    // BRANCA 0xM 2xGG
    // BRANCA 5xM 0xGG
  }
}
