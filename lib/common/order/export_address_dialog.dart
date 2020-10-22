import 'package:app_loja_virtual/models/order.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog({Key key, this.order}) : super(key: key);

  final Order order;
  final ScreenshotController screenshootController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exportar endereco'),
      content: Screenshot(
        controller: screenshootController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
              '${order.address.street}, ${order.address.number} \n ${order.address.complement} \n ${order.address.city} - ${order.address.state} - ${order.address.zipCode}'),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      actions: [
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await screenshootController.capture();
            await GallerySaver.saveImage(file.path);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
