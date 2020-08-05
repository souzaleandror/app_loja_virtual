import 'package:app_loja_virtual/models/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({this.iconData, this.title, this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: () {
        debugPrint('toquei $page');
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Icon(
                iconData,
                size: 32,
                color: curPage == page ? Colors.red : Colors.grey[700],
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            Text(
              title,
              style: TextStyle(
                  color: curPage == page ? Colors.red : Colors.grey[700]),
            )
          ],
        ),
      ),
    );
  }
}
