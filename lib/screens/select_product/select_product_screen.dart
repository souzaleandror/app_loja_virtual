import 'package:app_loja_virtual/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              final product = productManager.allProducts[index];
              // return GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).pop(product);
              //   },
              //   child: ProductListTile(product: product),
              // );
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  trailing: const Text('Selecionar'),
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product.images.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.of(context).pop(product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
