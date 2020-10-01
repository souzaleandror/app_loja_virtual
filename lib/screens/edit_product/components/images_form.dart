import 'dart:io';

import 'package:app_loja_virtual/models/product.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      //initialValue: product.images,
      //initialValue: product.images as List<dynamic>,
      initialValue: List.from(product.images),
      validator: (images) {
        if (images.isEmpty) {
          return 'Insira ao menos uma imagem';
        } else {
          return null;
        }
      },
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          color: Colors.red,
                          onPressed: () {
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList()
                  ..add(
                    Material(
                      color: Colors.grey[100],
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        color: Theme.of(context).primaryColor,
                        iconSize: 50,
                        onPressed: () {
                          if (Platform.isAndroid) {
                            //File file = await showModalBottomSheet(context: context, builder: (_) => ImageSourceSheet());
                            showModalBottomSheet(
                                context: context,
                                builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected));
                          } else {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected));
                          }
                        },
                      ),
                    ),
                  ),
                dotSize: 4,
                dotColor: Theme.of(context).primaryColor,
                dotBgColor: Colors.transparent,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
