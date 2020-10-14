import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class UserModel {
  UserModel(
      {this.id, this.name, this.email, this.password, this.confirmPassword});

  UserModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
    password = document.data()['password'] as String;
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
      if (address != null) 'address': address.toMap()
    };
  }

  CollectionReference get cartReference => firebaseRef.collection('cart');

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, password: $password, confirmPassword: $confirmPassword, admin: $admin}';
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }
}
