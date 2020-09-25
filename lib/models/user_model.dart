import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel(
      {this.id, this.name, this.email, this.password, this.confirmPassword});

  UserModel.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
    password = document.data()['password'] as String;
    confirmPassword = document.data()['confirmPassword'] as String;
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

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
      'confirmPassword': confirmPassword
    };
  }

  CollectionReference get cartReference => firebaseRef.collection('cart');
}
