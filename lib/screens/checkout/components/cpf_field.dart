import 'package:app_loja_virtual/models/user_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CpfField extends StatelessWidget {
  const CpfField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            TextFormField(
              initialValue: userManager.user.cpf,
              decoration: const InputDecoration(
                  hintText: '000.000.000-00', isDense: true),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter()
              ],
              validator: (cpf) {
                if (cpf.isEmpty) {
                  return 'Campo Obrigato';
                } else if (cpf.length != 14) {
                  return 'CPF Invalido';
                } else if (!CPFValidator.isValid(cpf)) return 'CPF Invalido';
                return null;
              },
              onSaved: userManager.user.setCpf,
            )
          ],
        ),
      ),
    );
  }
}
