import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'address.dart';

class UserModel {
  UserModel(
      {this.id, this.name, this.email, this.password, this.confirmPassword});

  UserModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
    password = document.data()['password'] as String;
    cpf = document.data()['cpf'] as String;
    confirmPassword = document.data()['confirmPassword'] as String;
    if (document.data().containsKey('address')) {
      if (document.data().containsKey('address')) {
        address =
            Address.fromMap(document.data()['address'] as Map<String, dynamic>);
      }
    }
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  String cpf;
  bool admin = false;
  Address address;

  DocumentReference get firebaseRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await firebaseRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      if (address != null) 'address': address.toMap(),
      if (cpf != null) 'cpf': cpf
    };
  }

  CollectionReference get cartReference => firebaseRef.collection('cart');

  CollectionReference get tokensReference => firebaseRef.collection('tokens');

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, password: $password, confirmPassword: $confirmPassword, admin: $admin}';
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    debugPrint("token: $token");
    await tokensReference.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }
}
