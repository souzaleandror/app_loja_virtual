import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({Key key, this.onImageSelected}) : super(key: key);

  final ImagePicker picker = ImagePicker();
  final Function(File) onImageSelected;
  Future<void> editImage(String path, BuildContext context)  async {
    final File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar Imagem',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Editar Imagem',
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Concluir',
      ),
    );
    if(croppedFile != null) {
      onImageSelected(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
                onPressed: () async {
                  PickedFile file =
                      await picker.getImage(source: ImageSource.camera);
                  //File(file.path);
                  //Navigator.of(context).pop(File(file.path));
                  editImage(file.path, context);
                  //onImageSelected(File(file.path));

                },
                child: const Text('Camera')),
            FlatButton(
                onPressed: () async {
                  PickedFile file =
                      await picker.getImage(source: ImageSource.gallery);
                  editImage(file.path, context);
                  //onImageSelected(File(file.path));
                },
                child: const Text('Galeria')),
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origim da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              PickedFile file =
                  await picker.getImage(source: ImageSource.camera);
              //File(file.path);
              //Navigator.of(context).pop(File(file.path));
              editImage(file.path, context);
              //onImageSelected(File(file.path));
            },
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              PickedFile file =
                  await picker.getImage(source: ImageSource.gallery);
              editImage(file.path, context);
              //onImageSelected(File(file.path));
            },
            child: const Text('Galeria'),
          ),
        ],
      );
    }
  }
}
