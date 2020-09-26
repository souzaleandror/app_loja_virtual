import 'package:app_loja_virtual/models/section.dart';
import 'package:app_loja_virtual/screens/home/components/item_tile.dart';
import 'package:app_loja_virtual/screens/home/components/section_header.dart';
import 'package:flutter/material.dart';

class SectionList extends StatelessWidget {
  const SectionList({Key key, this.section}) : super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(
            section: section,
          ),
          SizedBox(
              height: 150,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return ItemTile(item: section.items[index]);
                  },
                  separatorBuilder: (_, __) => const SizedBox(
                        width: 4,
                      ),
                  itemCount: section.items.length)),
        ],
      ),
    );
  }
}
