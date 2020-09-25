import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// leco@user.com 123123
Future<void> main() async {
  runApp(const MyApp());

  //Firestore.instance.collection('teste').add({'teste': 'teste'});
  FirebaseFirestore.instance.collection('teste2').add({'teste2': 'teste2'});
  // Criar
  FirebaseFirestore.instance
      .collection('pedidos')
      .add({'preco': 199.99, 'Usuario': 'Daniel'});
  FirebaseFirestore.instance
      .collection('pedidos')
      .doc('#00001')
      .set({'preco': 100.00, 'usuario': 'Leco'});
  FirebaseFirestore.instance
      .collection('pedidos')
      .doc('#00001')
      .set({'usuario': 'Leco2'});
  //Update
  FirebaseFirestore.instance
      .collection('pedidos')
      .doc('#00001')
      .update({'usuario': 'Leco2'});

  FirebaseFirestore.instance.doc('pedidos/#00001').update({'usuario': 'Leco3'});

  // get data
  final DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('teste')
      .doc('nWe9uCRzxNAu0WxCD85G')
      .get();

  debugPrint(doc.data().toString());
  debugPrint(doc.data()['teste'].toString());
  debugPrint(doc.data()['teste2'].toString());

  // Documento que nao existe
  final DocumentSnapshot document2 = await FirebaseFirestore.instance
      .collection('teste3')
      .doc('nWe9uCRzxNAu0WxCD85G2')
      .get();

  debugPrint(document2.data().toString());

  FirebaseFirestore.instance
      .collection('teste')
      .doc('nWe9uCRzxNAu0WxCD85G')
      .snapshots()
      .listen((document) {
    debugPrint(document.data().toString());
  });

  // Get todos os documentos em tempo real
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('pedidos').get();

  for (final DocumentSnapshot doc in snapshot.docs) {
    debugPrint(doc.data().toString());
  }

  // Get todos os documentos em tempo real
  FirebaseFirestore.instance
      .collection('pedidos')
      .snapshots()
      .listen((snapshot) {
    for (final DocumentSnapshot doc in snapshot.docs) {
      debugPrint(doc.data().toString());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
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
