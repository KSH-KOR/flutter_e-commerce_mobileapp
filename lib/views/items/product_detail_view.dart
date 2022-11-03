import 'dart:developer';

import 'package:finalterm/services/auth/auth_provider.dart';
import 'package:finalterm/services/cloud/firebase_cloud_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/product/model/product.dart';
import '../../services/product/product_provider.dart';
import '../../utils/helpers.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final authProvider = AuthProvider();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
          actions: [
            Visibility(
              visible: !productProvider.isEditing,
              child: IconButton(
                onPressed: () {
                  productProvider.toggleEditingMode();
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            Visibility(
              visible: !productProvider.isEditing,
              child: IconButton(
                onPressed: () {
                  productProvider.deleteProduct(product);
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 300,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: 
                      product.selectedImaged() ?? productProvider.defaultImage,
                ),
              ),
            ),
            addVerticalSpace(40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        
                      },
                      icon: const Icon(Icons.photo),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(product.name)),
                              TextButton.icon(
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
                            ],
                          ),
                          Text(product.price),
                          addVerticalSpace(10),
                          const Divider(height: 1.0, color: Colors.black),
                          addVerticalSpace(10),
                          Text(product.description),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("creator: ${product.creatorId}"),
                          Text(
                              "${DateTime.fromMillisecondsSinceEpoch(product.createdTime!.millisecondsSinceEpoch)} created"),
                          Text(
                              "${DateTime.fromMillisecondsSinceEpoch(product.modifiedTime!.millisecondsSinceEpoch)} modified"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
