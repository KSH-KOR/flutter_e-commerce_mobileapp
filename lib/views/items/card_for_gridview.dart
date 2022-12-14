import 'dart:io';

import 'package:finalterm/constant/routes.dart';
import 'package:finalterm/services/product/model/product.dart';
import 'package:finalterm/services/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridViewCard extends StatelessWidget {
  const GridViewCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  Widget _image({required Image image}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 20.0 / 11.0,
        child: image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final Image image =
        product.selectedImaged() ?? productProvider.defaultImage;

    return InkWell(
      onDoubleTap: () => productProvider.toggleWishList(product: product),
      child: Stack(
        children: [
          Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                _image(image: image),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name),
                        Text("\$ ${product.price}"),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                productProvider.currentProduct = product;
                                Navigator.of(context).pushNamed(detailRoute);
                              },
                              child: const Text("more"),
                            ),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: productProvider.isInWishList(product: product),
              child: const Icon(Icons.check_circle, color: Colors.green,),
            ),
          ),
        ],
      ),
    );
  }
}
