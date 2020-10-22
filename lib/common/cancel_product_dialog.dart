import 'package:app_loja_virtual/models/product.dart';
import 'package:app_loja_virtual/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CancelProductDialog extends StatelessWidget {
  const CancelProductDialog({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${product.name}'),
      content: const Text('Esta acao nao poderar ser desfeita!'),
      actions: [
        FlatButton(
          onPressed: () {
            context.read<ProductManager>().delete(product);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Deletar Produto'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.green,
          child: const Text('Apenas fechar'),
        ),
      ],
    );
  }
}
