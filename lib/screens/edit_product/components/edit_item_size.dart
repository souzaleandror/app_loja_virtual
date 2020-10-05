import 'package:app_loja_virtual/common/custom_icon_button.dart';
import 'package:app_loja_virtual/models/item_size.dart';
import 'package:flutter/material.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize(
      {Key key, this.size, this.onItemRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);

  final ItemSize size;
  final VoidCallback onItemRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              hintText: 'Titulo',
              isDense: true,
            ),
            validator: (name) {
              if (name.isEmpty) {
                return 'Nome invalido';
              } else {
                return null;
              }
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              hintText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (int.tryParse(stock) == null) {
                return 'Invalido';
              } else {
                return null;
              }
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              prefix: Text('R\$'),
              hintText: 'Preco',
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price) {
              if (num.tryParse(price) == null) {
                return 'Invalido';
              } else {
                return null;
              }
            },
            onChanged: (price) => size.price = num.tryParse(price),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onItemRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.red,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
