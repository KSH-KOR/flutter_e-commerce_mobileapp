import 'package:finalterm/constant/routes.dart';
import 'package:finalterm/services/cloud/firebase_cloud_product.dart';
import 'package:finalterm/services/product/model/product.dart';
import 'package:finalterm/services/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_provider.dart';
import '../widgets/dropdown_selector.dart';
import 'items/product_gridview.dart';

class ItemPageView extends StatefulWidget {
  const ItemPageView({super.key});

  @override
  State<ItemPageView> createState() => _ItemPageViewState();
}

class _ItemPageViewState extends State<ItemPageView> {
  late final FirebaseCloudProdcutStorage _cloudProductService;

  @override
  void initState() {
    _cloudProductService = FirebaseCloudProdcutStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(profileRoute);
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(wishListRoute);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    child: Stack(children: <Widget>[
                      Icon(Icons.brightness_1,
                          size: 20.0, color: Colors.orange),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              Provider.of<ProductProvider>(context, listen: true)
                                  .wishList
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500),
                            ),
                        ),
                      ),
                      
                    ]),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(addNewProductRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DropDownButton(dropdownList: DropdownValue.values),
            Consumer<ProductProvider>(
              builder: (context, product, child) {
                return StreamBuilder(
                  stream: _cloudProductService.allProducts(
                      isDescending:
                          product.dropdownValue == DropdownValue.desc),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allProducts =
                              snapshot.data as Iterable<Product>;
                          return ProductGridView(
                            products: allProducts,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
