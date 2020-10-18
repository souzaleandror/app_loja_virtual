import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class Order {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;
    items = (doc.data()['items'] as List<dynamic>).map((item){
      return CartProduct.fromMap(item as Map<String, dynamic>);
    }).toList();
    price = doc.data()['price'] as num;
    userId = doc.data()['user'] as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);
    date = doc.data()['date'] as Timestamp;
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'orderId': orderId,
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'userId': userId,
      'address': address.toMap(),
    });
  }

  @override
  String toString() {
    return 'Order{ orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
