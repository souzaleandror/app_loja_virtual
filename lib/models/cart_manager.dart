import 'package:app_loja_virtual/models/address.dart';
import 'package:app_loja_virtual/models/cart_product.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:app_loja_virtual/services/cepaberto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class CartManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<CartProduct> items = [];

  UserModel user;
  Address address;

  num productsPrice = 0;
  num deliveryPrice;
  num get totalPrice => productsPrice + (deliveryPrice ?? 0);
  bool get isAddressValid => address != null && deliveryPrice != null;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  Future<void> _loadCartItems() async {
    //user.firebaseRef.collection(cart);
    final QuerySnapshot cartSnap = await user.cartReference.get();

    items = cartSnap.docs
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdate))
        .toList();
  }

  Future<void> _loadUserAddress() async {
    if (user.address != null &&
        await calculateDelivery(address, address.latitude, address.longitude)) {
      address = user.address;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e, ex) {
      debugPrint('NAO E ERROR $e >>> $ex');
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id);
      _onItemUpdate();
    }
    notifyListeners();
  }

  void _onItemUpdate() {
    productsPrice = 0.0;
    debugPrint("_onItemUpdate");
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }
    debugPrint(productsPrice.toString());
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user.cartReference
          .doc(cartProduct.id)
          .update(cartProduct.toCartItemMap());
    }
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdate);
    notifyListeners();
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);
      debugPrint(cepAbertoAddress.toString());
      if (cepAbertoAddress != null) {
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          latitude: cepAbertoAddress.latitude,
          longitude: cepAbertoAddress.longitude,
          altitude: cepAbertoAddress.altitude,
        );
      }
      debugPrint(address.toString());
      loading = false;
      //notifyListeners();
    } catch (e, ex) {
      loading = false;
      debugPrint("$e >>> $ex");
      return Future.error('Cep Invalido :(');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;
    if (await calculateDelivery(
        this.address, address.latitude, address.longitude)) {
      debugPrint('deliveryPrice $deliveryPrice');
      user.setAddress(address);
      loading = false;
      //notifyListeners();
    } else {
      loading = false;
      return Future.error('Endereco fora do raio de entrega :(');
    }
  }

  Future<bool> calculateDelivery(
      Address address, double latitude, double longitude) async {
    final DocumentSnapshot doc = await firestore.doc('/aux/delivery').get();
    final latStore = doc.data()['lat'] as double;
    final longStore = doc.data()['long'] as double;
    final maxkm = doc.data()['maxkm'] as num;
    final base = doc.data()['base'] as num;
    final km = doc.data()['km'] as num;

    double dis = distanceBetween(latStore, longStore, latitude, longitude);

    debugPrint('Distance $dis');

    dis /= 1000.0;

    debugPrint('Distance $dis');

    if (dis > maxkm) {
      return false;
    }

    deliveryPrice = base + dis * km;

    debugPrint('deliveryPrice $deliveryPrice');
    return true;
  }
}
