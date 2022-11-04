import 'package:finalterm/services/product/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: productProvider.wishList.length,
        itemBuilder: (context, index) {
          final product = productProvider.wishList.elementAt(index);
          return ListTile(
            leading: product.selectedImaged() ?? productProvider.defaultImage,
            title: Text(product.name),
            trailing: IconButton(
              onPressed: () {
                productProvider.removeProductFromWishList(product: product);
              },
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    ));
  }
}
