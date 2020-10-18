
import 'dart:async';

import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'order.dart';

class OrdersManager extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  UserModel user;
  List<Order> orders = [];

  void updateUser(UserModel user) {
    this.user = user;
    orders.clear();

    _subscription?.cancel();
    if(user != null) {
      _listenToOrders();
    }
    notifyListeners();
  }

  void _listenToOrders() {

    _subscription = firestore.collection('orders').where('userId', isEqualTo: user.id).snapshots().listen((event) {
      orders.clear();

      for(final doc in event.docs) {
        orders.add(Order.fromDocument(doc));
      }

      debugPrint(orders.toString());
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}