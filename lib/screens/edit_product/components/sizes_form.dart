import 'package:app_loja_virtual/common/custom_icon_button.dart';
import 'package:app_loja_virtual/models/item_size.dart';
import 'package:app_loja_virtual/models/product.dart';
import 'package:flutter/material.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      //initialValue: List.from(product.sizes),
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) {
          return 'Precisa de um tamanho';
        } else {
          return null;
        }
      },
      builder: (state) {
        debugPrint(state.toString());
        return Column(
          children: [
            Row(
              children: <Widget>[
                const Text(
                  'Tamanhos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
              children: state.value.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onItemRemove: () {
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveDown: size != state.value.last
                      ? () {
                          final index = state.value.indexOf(size);
                          state.value.remove(size);
                          state.value.insert(index + 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                  onMoveUp: size != state.value.first
                      ? () {
                          final index = state.value.indexOf(size);
                          state.value.remove(size);
                          state.value.insert(index - 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
