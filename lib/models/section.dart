import 'dart:io';

import 'package:app_loja_virtual/models/section_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home/$id');

  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  @override
  String toString() {
    return 'Section{id: $id, name: $name, type: $type, items: $items}';
  }

  Section clone() {
    return Section(
        id: id,
        name: name,
        type: type,
        items: items.map((e) => e.clone()).toList());
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  bool valid() {
    if (name == null || name.isEmpty) {
      error = 'Titulo Invalido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }

    return error == null;
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final UploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);
        //final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await task.snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      try {
        if (!items.contains(original) &&
            (original.image as String).contains('firebase')) {
          // final ref = await storage.getReferenceFromUrl(original.image as String);
          // await ref.delete();
          await storage.refFromURL(original.image.toString()).delete();
        }
      } catch (e, ex) {
        debugPrint("$e >> $ex");
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      if ((item.image as String).contains('firebase')) {
        try {
          // final ref = await storage.getReferenceFromUrl(item.image as String);
          // await ref.delete();
          storage.refFromURL(item.image.toString()).delete();
        } catch (e, ex) {
          debugPrint("$e >>> $ex");
        }
      }
    }
  }
}
