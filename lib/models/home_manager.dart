import 'package:app_loja_virtual/models/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeManager extends ChangeNotifier {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  List<Section> sections = [];

  HomeManager() {
    _loadAllSections();
  }

  Future<void> _loadAllSections() async {
    _firebase.collection('home').snapshots().listen((snapshot) {
      sections.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        sections.add(Section.fromDocument(document));
        debugPrint(sections.toString());
      }
      debugPrint(sections.toString());
    });
    notifyListeners();
  }
}
