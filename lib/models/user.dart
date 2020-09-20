import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({this.id, this.name, this.email, this.password, this.confirmPassword});

  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
    password = document.data['password'] as String;
    confirmPassword = document.data['confirmPassword'] as String;
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

  DocumentReference get firebaseRef => Firestore.instance.document('users/$id');

  Future<void> saveData() async {
    await firebaseRef.setData(toMap());
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
