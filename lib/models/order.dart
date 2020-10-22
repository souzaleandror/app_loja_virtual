import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'address.dart';

enum Status { canceled, preparing, transporting, delivered }

class Order extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;
  Status status;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  DocumentReference get docRef => firestore.collection('orders').doc(orderId);

  Function() get back {
    return (status.index >= Status.transporting.index)
        ? () {
            status = Status.values[status.index - 1];
            docRef.update({'status': status.index});
          }
        : null;
  }

  Function() get advanced {
    return (status.index <= Status.transporting.index)
        ? () {
            status = Status.values[status.index + 1];
            docRef.update({'status': status.index});
          }
        : null;
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;
    items = (doc.data()['items'] as List<dynamic>).map((item) {
      return CartProduct.fromMap(item as Map<String, dynamic>);
    }).toList();
    price = doc.data()['price'] as num;
    userId = doc.data()['user'] as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);
    date = doc.data()['date'] as Timestamp;
    status = Status.values[doc.data()['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'orderId': orderId,
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'userId': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now()
    });
  }

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparacao';
      case Status.transporting:
        return 'Em Transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return 'Nenhum Status';
    }
  }

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data()['status'] as int];
  }

  void cancel() {
    status = Status.canceled;
    docRef.update({'status': status.index});
  }

  @override
  String toString() {
    return 'Order{ orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
