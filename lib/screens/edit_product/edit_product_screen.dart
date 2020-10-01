import 'package:app_loja_virtual/models/product.dart';
import 'package:flutter/material.dart';

import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen({Key key, this.product}) : super(key: key);

  final Product product;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            ImagesForm(product: product),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: product.name,
                    decoration: const InputDecoration(
                      hintText: 'Titulo (Nome do Produto)',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    validator: (name) {
                      if (name.length < 6) {
                        return 'Titulo muito curto';
                      } else {
                        return null;
                      }
                    },
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
                    'R\$ ...',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: product.description,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Descricao do produto',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    validator: (desc) {
                      if (desc.length < 10) {
                        return 'Descricao muita curto';
                      } else {
                        return null;
                      }
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        debugPrint('valido!!');
                      } else {
                        debugPrint('Invalido!!');
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
