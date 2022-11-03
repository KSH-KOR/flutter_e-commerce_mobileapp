import 'package:flutter/material.dart';

import '../../services/product/model/product.dart';
import 'card_for_gridview.dart';


class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key, required this.products});
  final Iterable<Product> products;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (width < height) ? 2 : 3,
              childAspectRatio: 8.0 / 9.0),
          itemBuilder: (context, index) {
            final Product product = products.elementAt(index);
            return GridViewCard(
              product: product,
            );
          },
        );
      },
    );
  }
}
