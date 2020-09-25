import 'package:app_loja_virtual/models/item_size.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    productId = document.data()['productId'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;
    firestore
        .doc('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }

  Product product;

  String productId;
  String size;
  int quantity;

  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }
}
