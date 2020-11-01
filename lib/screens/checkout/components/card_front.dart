import 'package:app_loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {
  CardFront(
      {Key key,
      this.finished,
      this.numberFocus,
      this.nameFocus,
      this.dateFocus})
      : super(key: key);

  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final VoidCallback finished;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        color: const Color(0xFF1B4B52),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CardTextField(
                    title: 'Numero',
                    hint: '0000 0000 0000 0000',
                    bold: true,
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter()
                    ],
                    validator: (number) {
                      if (number.length != 19) {
                        return "Invalido";
                      } else if (detectCCType(number) ==
                          CreditCardType.unknown) {
                        return "Invalido";
                      }
                      return null;
                    },
                    focusNode: numberFocus,
                    onSubmitted: (_) {
                      dateFocus.requestFocus();
                    },
                  ),
                  CardTextField(
                    title: 'Validade',
                    hint: '11/2020',
                    textInputType: TextInputType.number,
                    inputFormatters: [dateFormatter],
                    validator: (data) {
                      if (data.length != 7) {
                        return "Invalido";
                      }
                      return null;
                    },
                    focusNode: dateFocus,
                    onSubmitted: (_) {
                      nameFocus.requestFocus();
                    },
                  ),
                  CardTextField(
                    title: 'Titular',
                    hint: 'João da Silva',
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (nome) {
                      if (nome.isEmpty) {
                        return "Invalido";
                      }
                      return null;
                    },
                    focusNode: nameFocus,
                    onSubmitted: (_) {
                      finished();
                    },
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
