import 'dart:io';

import 'package:app_loja_virtual/models/section.dart';
import 'package:app_loja_virtual/models/section_item.dart';
import 'package:app_loja_virtual/screens/edit_product/components/image_source_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {
  const AddTileWidget({Key key, this.section}) : super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final section2 = context.watch<Section>();
    void onImageSelected(File file) {
      section2.addItem(SectionItem(image: file));

      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            showModalBottomSheet(
              context: context,
              builder: (context) =>
                  ImageSourceSheet(onImageSelected: onImageSelected),
            );
          } else {
            showCupertinoModalPopup(
              context: context,
              builder: (context) =>
                  ImageSourceSheet(onImageSelected: onImageSelected),
            );
          }
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
