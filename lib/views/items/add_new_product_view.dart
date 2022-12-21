

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm/services/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/cloud/firebase_cloud_product.dart';
import '../../services/product/product_provider.dart';
import '../../widgets/image_selector.dart';

class AddNewProductView extends StatelessWidget {
  AddNewProductView({super.key});

  final productName = TextEditingController();
  final price = TextEditingController();
  final description = TextEditingController();
  final productService = FirebaseCloudProdcutStorage();
  final authProvider = AuthProvider();

  bool isVideo = false;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              productProvider.imagePath = null;
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                
                final imagePath =
                    Provider.of<ProductProvider>(context, listen: false)
                        .imagePath;
                final serverTime = FieldValue.serverTimestamp();
                final productId = const Uuid().v4();
                if (imagePath != null) {
                  await productService.uploadFileToCloud(imagePath, productId);
                  Provider.of<ProductProvider>(context, listen: false)
                      .imagePath = null;
                }
                final String? imageDownloadURL = await productService.getImageDownloadURL(cloudRef: productId);
                productService.createNewProduct(
                  imagePath: imageDownloadURL,
                  name: productName.text.isEmpty
                      ? "No Name Yet"
                      : productName.text,
                  price: price.text.isEmpty ? 0 : int.parse(price.text),
                  description: description.text.isEmpty
                      ? "No Description Yet"
                      : description.text,
                  createdTime: serverTime,
                  modifiedTime: serverTime,
                  creatorId: authProvider.currentUser!.id,
                  productId: productId,
                  likeCount: 0,
                );
                
                Navigator.of(context).pop();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: productProvider.selectedImage ??
                      productProvider.defaultImage,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  ImageSelector(),
                ],
              ),
              TextField(
                controller: productName,
              ),
              TextField(
                controller: price,
              ),
              TextField(
                controller: description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
