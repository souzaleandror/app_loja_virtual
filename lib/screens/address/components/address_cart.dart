import 'package:app_loja_virtual/models/address.dart';
import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'address_input_field.dart';
import 'cep_input_field.dart';

class AddressCart extends StatelessWidget {
  const AddressCart({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Consumer<CartManager>(
            builder: (_, cartManager, __) {
              final address = cartManager.address ?? Address();
              debugPrint(address.toString());
              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Endereco de entrega',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    CepInputField(
                      address: address,
                    ),
                    if (address.zipCode != null)
                      AddressInputField(
                        address: address,
                      ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
