import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class Order {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  Future<void> save() async {
    _firestore.collection('orders').doc(orderId).set({
      'orderId': orderId,
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'userId': userId,
      'address': address.toMap(),
    });
  }
}
