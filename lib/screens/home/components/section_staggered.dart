import 'package:app_loja_virtual/models/home_manager.dart';
import 'package:app_loja_virtual/models/section.dart';
import 'package:app_loja_virtual/screens/home/components/add_tile_widget.dart';
import 'package:app_loja_virtual/screens/home/components/item_tile.dart';
import 'package:app_loja_virtual/screens/home/components/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  const SectionStaggered({Key key, this.section}) : super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    //final section2 = context.watch<Section>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(
              section: section,
            ),
            Consumer<Section>(
              builder: (_, section, __) {
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeManager.editing
                      ? section.items.length + 1
                      : section.items.length,
                  itemBuilder: (_, index) {
                    if (index < section.items.length) {
                      return ItemTile(item: section.items[index]);
                    } else {
                      return AddTileWidget(
                        section: section,
                      );
                    }
                  },
                  staggeredTileBuilder: (index) =>
                      StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
