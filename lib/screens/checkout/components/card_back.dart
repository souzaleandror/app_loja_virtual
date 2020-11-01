import 'package:app_loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardBack extends StatelessWidget {
  const CardBack({Key key, this.cvvFocus}) : super(key: key);

  final FocusNode cvvFocus;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        color: const Color(0xFF1B4B52),
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Container(
                    color: Colors.grey[500],
                    margin: const EdgeInsets.only(left: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    alignment: Alignment.centerRight,
                    child: CardTextField(
                      title: 'code',
                      hint: '123',
                      bold: false,
                      maxLength: 4,
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      cardBack: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (cvv) {
                        if (cvv.length <= 3) return 'Invalido';
                        return null;
                      },
                      focusNode: cvvFocus,
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
