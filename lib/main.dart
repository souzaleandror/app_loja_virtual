import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// leco@user.com 123123
void main() async {
  runApp(MyApp());

  //Firestore.instance.collection('teste').add({'teste': 'teste'});
  Firestore.instance.collection('teste2').add({'teste2': 'teste2'});
  // Criar
  Firestore.instance
      .collection('pedidos')
      .add({'preco': 199.99, 'Usuario': 'Daniel'});
  Firestore.instance
      .collection('pedidos')
      .document('#00001')
      .setData({'preco': 100.00, 'usuario': 'Leco'});
  Firestore.instance
      .collection('pedidos')
      .document('#00001')
      .setData({'usuario': 'Leco2'});
  //Update
  Firestore.instance
      .collection('pedidos')
      .document('#00001')
      .updateData({'usuario': 'Leco2'});

  Firestore.instance
      .document('pedidos/#00001')
      .updateData({'usuario': 'Leco3'});

  // get data
  DocumentSnapshot document = await Firestore.instance
      .collection('teste')
      .document('nWe9uCRzxNAu0WxCD85G')
      .get();

  print(document.data);
  print(document.data['teste']);
  print(document.data['teste2']);

  // Documento que nao existe
  DocumentSnapshot document2 = await Firestore.instance
      .collection('teste3')
      .document('nWe9uCRzxNAu0WxCD85G2')
      .get();

  Firestore.instance
      .collection('teste')
      .document('nWe9uCRzxNAu0WxCD85G')
      .snapshots()
      .listen((document) {
    print(document.data);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(),
    );
  }
}
