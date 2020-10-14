import 'package:app_loja_virtual/common/custom_icon_button.dart';
import 'package:app_loja_virtual/models/address.dart';
import 'package:app_loja_virtual/models/cart_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  const CepInputField({Key key, this.address}) : super(key: key);
  // : cepController = TextEditingController(text: address.zipCode),
  //   super(
  //     key: key,
  //   );

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;
    String vcep;
    //cepController.text = widget.address.zipCode;

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '12.123.-123',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter()
            ],
            validator: (cep) {
              if (cep.isEmpty) {
                return 'Campo Obrigatorio';
              } else if (cep.length != 10) {
                return 'CEP Invalido';
              } else {
                return null;
              }
            },
            onChanged: (text) => vcep = text,
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      //context.read<CartManager>().getAddress(vcep);
                      try {
                        debugPrint(vcep.toString());
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e, ex) {
                        debugPrint('$e >>> $ex');
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  }
                : null,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            textColor: Colors.white,
            child: const Text('Buscar CEP'),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }
  }
}
