import 'package:app_loja_virtual/common/order/cancel_order_dialog.dart';
import 'package:app_loja_virtual/common/order/export_address_dialog.dart';
import 'package:app_loja_virtual/models/order.dart';
import 'package:flutter/material.dart';

import 'order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({Key key, this.order, this.showControls = false})
      : super(key: key);

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
                Text(
                  "R\$ ${order.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  color: order.status == Status.canceled
                      ? Colors.red
                      : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items
                .map(
                    (cartProduct) => OrderProductTile(cartProduct: cartProduct))
                .toList(),
          ),
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => CancelOrderDialog(order: order));
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.back,
                    textColor: Colors.redAccent,
                    child: const Text(' << Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.advanced,
                    textColor: Colors.green,
                    child: const Text('Avancar >> '),
                  ),
                  FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => ExportAddressDialog(order: order));
                    },
                    textColor: Theme.of(context).primaryColor,
                    child: const Text('Endereco'),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
