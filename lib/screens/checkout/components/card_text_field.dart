import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField(
      {Key key,
      this.title,
      this.validator,
      this.textInputType,
      this.hint,
      this.bold = false,
      this.inputFormatters,
      this.maxLength,
      this.textAlign = TextAlign.start,
      this.cardBack = false,
      this.focusNode,
      this.onSubmitted,
      this.onSaved})
      : textInputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next,
        super(key: key);

  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextAlign textAlign;
  final bool cardBack;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      onSaved: onSaved,
      initialValue: '',
      validator: validator,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment:
                    cardBack ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      textAlign: textAlign,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  if (state.hasError)
                    Text(
                      '    Invaliado',
                      textAlign: textAlign,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                ],
              ),
              TextFormField(
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
                maxLength: maxLength,
                textAlign: textAlign,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: title == null && state.hasError
                      ? Colors.red
                      : Colors.white,
                  fontWeight: bold ? FontWeight.bold : null,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: title == null && state.hasError
                        ? Colors.red.withAlpha(200)
                        : Colors.white.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                ),
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                onChanged: (text) {
                  state.didChange(text);
                },
                textInputAction: textInputAction,
              )
            ],
          ),
        );
      },
    );
  }
}
