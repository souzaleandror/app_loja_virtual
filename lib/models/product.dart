import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'item_size.dart';

class Product extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  StorageReference get storageRef => storage.ref().child('products').child(id);

  Product(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.sizes,
      this.deleted = false}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    description = document.data()['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    sizes = (document.data()['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
    deleted = (document.data()['deleted'] ?? false) as bool;

    debugPrint(sizes.toString());
  }

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  List<dynamic> newImages;

  ItemSize _selectedSize;
  bool deleted;

  ItemSize get selectedSize => _selectedSize;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    loading = value;
    notifyListeners();
  }

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      //if (size.price < lowest && size.hasStock) {
      if (size.price < lowest) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0 && !deleted;
  }

  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e, ex) {
      debugPrint('$e >>> $ex');
      return null;
    }
  }

  Product clone() {
    return Product(
        id: id,
        name: name,
        description: description,
        images: List.from(images),
        sizes: sizes.map((size) => size.clone()).toList(),
        deleted: deleted);
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  DocumentReference get firestoreRef => firestore.doc('products/$id');

  Future<void> save() async {
    _loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': false
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      firestoreRef.update(data);
    }

    // IMAGES [URL1, URL2, URL3]
    // NEWIMAGES [URL2, URL3]
    // NEWIMAGES [URL2, URL3, FILE1, FILE2]
    // UPDATED [URL2, URL3, FURL1, FURL2]

    // MANDA FILE1 PRO STORAGE -> FURL1
    // MANDA FILE2 PRO STORAGE -> FURL2
    // EXCLUI IMAGEM URL1 DO STORAGE

    // NEW EXAMPLE
    // [URL1, URL2, URL3]
    // NEWIMAGES [URL3, FILE1]
    // UPDATE [URL3, FILE1]

    // MANDA FILE1 PRO STORAGE -> FURL1
    // EXCLUI IMAGEM URL1 DO STORAGE
    // EXCLUI IMAGEM URL2 DO STORAGE

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e, ex) {
          debugPrint('Falha ao tentar deletar $e >>> $ex');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});

    images = updateImages;

    _loading = false;
  }

  void delete() {
    firestoreRef.update({'deleted': true});
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages, _selectedSize: $_selectedSize}';
  }
}
