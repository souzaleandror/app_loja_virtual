import 'package:app_loja_virtual/models/item_size.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartProduct extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Product product;
  String id;
  String productId;
  String size;
  int quantity;
  num fixedPrice;

  CartProduct.fromProduct(this._product) {
    id = product.id;
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    productId = document.data()['productId'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;
    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['productId'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;
    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  Product _product;
  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  bool get hasStock {
    if (product != null && product.deleted) return false;

    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }
}
