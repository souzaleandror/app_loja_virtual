import 'dart:async';

import 'package:app_loja_virtual/models/order.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminOrdersManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  List<Order> _orders = [];
  UserModel userFilter;
  Timestamp timeFilter;
  List<Status> statusFilter = [Status.preparing];

  void updateAdmin({bool adminEnabled}) {
    _orders.clear();

    _subscription?.cancel();
    if (adminEnabled) {
      _listenToOrders();
    }
    notifyListeners();
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if (userFilter != null) {
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    if (timeFilter != null) {
      output = output.where((o) => o.date == Timestamp.now()).toList();
    }

    return output =
        output.where((o) => statusFilter.contains(o.status)).toList();
    ;
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen((event) {
      //orders.clear();
      // for (final doc in event.docs) {
      //   orders.add(Order.fromDocument(doc));
      // }
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder =
                _orders.firstWhere((o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            debugPrint('Deu um problema serio!!');
            break;
        }
      }

      debugPrint(_orders.toString());
      notifyListeners();
    });
  }

  void setStatusFilter({Status status, bool enabled}) {
    if (enabled) {
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  void setUserFilter(UserModel user) {
    userFilter = user;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
