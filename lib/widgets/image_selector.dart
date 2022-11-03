import 'dart:developer';
import 'dart:io';

import 'package:finalterm/services/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageSelector extends StatelessWidget {
  const ImageSelector({super.key, this.defaultImageURL});

  final String? defaultImageURL;

  Future<String?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return image.path;
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: true);
    return InkWell(
      onTap: () async {
        final pickedFilePath = pickImage();
        productProvider.imagePath = await pickedFilePath;
      },
      child: productProvider.imagePath == null ? productProvider.defaultImage : productProvider.selectedImage,
    );
  }
}
