import 'package:app_loja_virtual/models/home_manager.dart';
import 'package:app_loja_virtual/models/section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget({Key key, this.homeManager2}) : super(key: key);

  final HomeManager homeManager2;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return Row(
      children: <Widget>[
        Expanded(
            child: FlatButton(
          onPressed: () {
            homeManager.addSection(Section(type: 'List'));
          },
          color: Colors.white,
          child: const Text('Adicionar Lista'),
        )),
        Expanded(
            child: FlatButton(
          onPressed: () {
            homeManager.addSection(Section(type: 'Staggered'));
          },
          color: Colors.white,
          child: const Text('Adicionar Grade'),
        )),
      ],
    );
  }
}
