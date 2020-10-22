import 'package:app_loja_virtual/common/cancel_product_dialog.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:app_loja_virtual/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p, {Key key})
      : editing = p != null,
        product = p != null ? p.clone() : Product(),
        super(key: key);

  final Product product;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final bool editing;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: editing
              ? const Text('Editar Produto')
              : const Text('Criar Produto'),
          centerTitle: true,
          actions: [
            if (editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => CancelProductDialog(product: product));
                },
              )
          ],
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
                      onSaved: (name) => product.name = name,
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
                      onSaved: (description) =>
                          product.description = description,
                    ),
                    SizesForm(product: product),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      debugPrint('valido!!');
                                      formKey.currentState.save();
                                      debugPrint(product.sizes.toString());
                                      await product.save();

                                      context
                                          .read<ProductManager>()
                                          .update(product);

                                      Navigator.of(context).pop();
                                    } else {
                                      debugPrint('Invalido!!');
                                    }
                                  }
                                : null,
                            textColor: Colors.white,
                            color: primary,
                            disabledColor: primary.withAlpha(100),
                            child: !product.loading
                                ? const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                : const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
