import 'package:app_loja_virtual/models/order.dart';
import 'package:flutter/material.dart';

import 'order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({Key key, this.order}) : super(key:key);

  final Order order;

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
                Text(order.formattedId, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                Text("R\$ ${order.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14,),),
              ],
            ),
            const Text("Entregue", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),),
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items.map((cartProduct) => OrderProductTile(cartProduct: cartProduct) ).toList(),
          )
        ],
      ),
    );
  }
}

