import 'package:app_loja_virtual/models/cart_product.dart';
import 'package:flutter/material.dart';

class OrderProductTile extends StatelessWidget {
  const OrderProductTile({Key key, this.cartProduct}) : super(key:key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: cartProduct.product);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4,),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(cartProduct.product.images.first,),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cartProduct.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17
                    ),
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'Preco: R\$ ${cartProduct.fixedPrice ?? cartProduct.unitPrice}',
                    style:  TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${cartProduct.quantity}',
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
          ],
        ),
      ),
    );
  }
}
