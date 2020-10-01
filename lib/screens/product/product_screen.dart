import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(product.name),
            centerTitle: true,
            actions: [
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/edit_product',
                            arguments: product);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
          body: ListView(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Carousel(
                  images: product.images.map((url) {
                    return NetworkImage(url);
                  }).toList(),
                  dotSize: 4,
                  dotColor: Theme.of(context).primaryColor,
                  dotBgColor: Colors.transparent,
                  autoplay: false,
                  dotSpacing: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${product.basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Tamanhos',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.sizes.map((s) {
                        return SizeWidget(size: s);
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (product.hasStock)
                      Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                          return SizedBox(
                            height: 44,
                            child: RaisedButton(
                              color: primary,
                              textColor: Colors.white,
                              onPressed: product.selectedSize != null
                                  ? () {
                                      if (userManager.isLoggedIn) {
                                        //  TODO: ADICIONAR AO CARRINHO
                                        context
                                            .read<CartManager>()
                                            .addToCart(product);
                                        Navigator.of(context)
                                            .pushNamed('/cart');
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed('/login');
                                      }
                                    }
                                  : null,
                              child: userManager.isLoggedIn
                                  ? const Text("Adicionar Carrinho")
                                  : const Text("Entre para comprar"),
                            ),
                          );
                        },
                      )
                    else
                      Container(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
