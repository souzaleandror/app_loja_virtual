import 'package:app_loja_virtual/models/order.dart';
import 'package:flutter/material.dart';

class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog({Key key, this.order}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}'),
      content: const Text('Esta acao nao poderar ser fesfeita!'),
      actions: [
        FlatButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Cancelar Pedido'),
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
