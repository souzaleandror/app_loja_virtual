import 'dart:async';

import 'package:app_loja_virtual/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoreList();
    _startTimer();
  }

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  List<Store> stores = [];
  Timer _timer;

  Future<void> _loadStoreList() async {
    final snapshot = await _firebase.collection('stores').get();
    debugPrint(snapshot.toString());

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();

    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
