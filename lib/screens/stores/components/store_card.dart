import 'package:app_loja_virtual/common/custom_icon_button.dart';
import 'package:app_loja_virtual/models/store.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({Key key, this.store}) : super(key: key);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    void showError() {
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('Este dispositivo nao possui essa funcao'),
        backgroundColor: Colors.red,
      ));
    }

    Future<void> openPhone() async {
      if (await canLaunch('tel:${store.cleanPhone}')) {
        launch('tel:${store.cleanPhone}');
      } else {
        showError();
      }
    }

    Future<void> openMap() async {
      try {
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
            context: context,
            builder: (_) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final map in availableMaps)
                      ListTile(
                        onTap: () {
                          map.showMarker(
                            coords: Coords(
                              store.address.latitude,
                              store.address.longitude,
                            ),
                            title: store.name,
                            description: store.addressText,
                          );
                          Navigator.of(context).pop();
                        },
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          width: 30,
                          height: 30,
                        ),
                      )
                  ],
                ),
              );
            });
      } catch (e, ex) {
        debugPrint("$e >>> $ex");
        showError();
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: <Widget>[
          Container(
            height: 140,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  store.image,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        store.statusText,
                        style: TextStyle(
                            color: colorForStatus(store.status),
                            fontWeight: FontWeight.w800,
                            fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        store.addressText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        store.openingText,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomIconButton(
                      iconData: Icons.map,
                      color: primaryColor,
                      onTap: openMap,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: primaryColor,
                      onTap: openPhone,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color colorForStatus(StoreStatus status) {
    switch (status) {
      case StoreStatus.open:
        return Colors.green;
        break;
      case StoreStatus.closing:
        return Colors.amber;
        break;
      case StoreStatus.closed:
        return Colors.red;
        break;
      default:
        return Colors.black;
    }
  }
}
