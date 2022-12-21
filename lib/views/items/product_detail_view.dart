import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm/services/auth/auth_provider.dart';
import 'package:finalterm/services/cloud/firebase_cloud_product.dart';
import 'package:finalterm/widgets/image_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/product/model/product.dart';
import '../../services/product/product_provider.dart';
import '../../utils/helpers.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final productProviderWithoutListening = Provider.of<ProductProvider>(context, listen: false);
    final product = productProviderWithoutListening.currentProduct!;
    final authProvider = AuthProvider();
    final productService = FirebaseCloudProdcutStorage();

    final productNameTEC = TextEditingController(text: product.name);
    final productPriceTEC = TextEditingController(text: product.price.toString());
    final productDescriptionTEC = TextEditingController(text: product.description);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
          leading: BackButton(
            onPressed: () {
              productProvider.isEditing = false;
              productProviderWithoutListening.imagePath = null;
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Visibility(
              visible: !productProvider.isEditing,
              child: IconButton(
                onPressed: product.creatorId != authProvider.currentUser!.id ? null : () {
                  productProvider.toggleEditingMode();
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            Visibility(
              visible: !productProvider.isEditing,
              child: IconButton(
                onPressed: product.creatorId != authProvider.currentUser!.id ? null : () {
                  productProvider.deleteProduct(product);
                  authProvider.cancelFavoriteProduct(productId: product.productId);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete),
              ),
            ),
            Visibility(
              visible: productProvider.isEditing,
              child: TextButton(
                onPressed: () async {
                  final imagePath =
                      Provider.of<ProductProvider>(context, listen: false)
                          .imagePath;
                  final serverTime = FieldValue.serverTimestamp();
                  if (imagePath != null) {
                    await productService.updateFileToCloud(
                        imagePath, product.productId);
                    Provider.of<ProductProvider>(context, listen: false)
                        .imagePath = null;
                  }
                  final imageDownloadURL = await productService.getImageDownloadURL(cloudRef: product.productId);
                  await productService.fetch(
                    imagePath: imageDownloadURL,
                    name: productNameTEC.text.isEmpty ? null : productNameTEC.text,
                    price: productPriceTEC.text.isEmpty ? null : int.parse(productPriceTEC.text),
                    description: productDescriptionTEC.text.isEmpty ? null : productDescriptionTEC.text,
                    modifiedTime: serverTime,
                    docId: product.docId,
                    productId: product.productId,
                    likeCount: product.likeCount,
                  );
                  productProvider.toggleEditingMode();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 300,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: productProvider.isEditing ? productProvider.selectedImage ?? product.selectedImaged() ?? productProvider.defaultImage:
                      product.selectedImaged() ?? productProvider.defaultImage,
                ),
              ),
            ),
            addVerticalSpace(40),
            Visibility(
              visible: productProvider.isEditing,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  ImageSelector(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          productProvider.isEditing
                              ? Flexible(
                                  child: TextField(
                                  controller: productNameTEC,
                                ))
                              : Flexible(child: Text(product.name)),
                          Visibility(
                            visible: !productProvider.isEditing,
                            child: TextButton.icon(
                              onPressed: () async {
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                final SnackBar snackBar;
                                if (await authProvider.addFavoriteProduct(
                                    productId: product.productId)) {
                                  productProvider.favoriteProduct(product);
                                  snackBar = const SnackBar(
                                    content: Text('I like it!'),
                                  );
                                } else {
                                  snackBar = const SnackBar(
                                    content: Text('You can only do once!'),
                                  );
                                }
                                scaffoldMessenger.showSnackBar(snackBar);
                              },
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              label: Text(product.likeCount.toString()),
                            ),
                          ),
                        ],
                      ),
                      productProvider.isEditing
                          ? TextField(
                              controller: productPriceTEC,
                            )
                          : Text(product.price.toString()),
                      addVerticalSpace(10),
                      Visibility(
                        visible: !productProvider.isEditing,
                        child: const Divider(height: 1.0, color: Colors.black),
                      ),
                      addVerticalSpace(10),
                      productProvider.isEditing
                          ? TextField(
                              controller: productDescriptionTEC,
                            )
                          : Text(product.description),
                    ],
                  ),
                  Visibility(
                    visible: !productProvider.isEditing,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("creator: ${product.creatorId}"),
                        Text(
                            "${DateTime.fromMillisecondsSinceEpoch(product.createdTime!.millisecondsSinceEpoch)} created"),
                        Text(
                            "${DateTime.fromMillisecondsSinceEpoch(product.modifiedTime!.millisecondsSinceEpoch)} modified"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          productProvider.toggleWishList();
        },
        child: productProvider.isInWishList() ? const Icon(Icons.check) : const Icon(Icons.shopping_cart),),
      ),
    );
  }
}
