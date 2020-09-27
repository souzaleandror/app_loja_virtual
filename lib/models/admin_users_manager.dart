import 'dart:async';

import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminUsersManager extends ChangeNotifier {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  List<UserModel> users = [];

  StreamSubscription _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  Future<void> _listToUsers() async {
    // const faker = Faker();
    // for (int i = 0; i < 1000; i++) {
    //   users.add(
    //       UserModel(name: faker.person.name(), email: faker.internet.email()));
    // }

    firebase.collection('users').get().then((snapshot) {
      users = snapshot.docs.map((d) => UserModel.fromDocument(d)).toList();
      //snapshot.docs.map((d) => users.add(UserModel.fromDocument(d)));
    });

    _subscription = firebase.collection('users').snapshots().listen((snapshot) {
      users = snapshot.docs.map((d) => UserModel.fromDocument(d)).toList();
      //snapshot.docs.map((d) => users.add(UserModel.fromDocument(d)));
    });

    users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
