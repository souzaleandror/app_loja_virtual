import 'package:app_loja_virtual/models/cart_product.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:app_loja_virtual/models/user.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartManager {
  List<CartProduct> items = [];

  User user;

  updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    //user.firebaseRef.collection(cart);
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    items = cartSnap.documents.map((d) => CartProduct.fromDocument(d)).toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.quantity++;
    } catch (e, ex) {
      final cartProduct = CartProduct.fromProduct(product);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap());
    }
  }
}
