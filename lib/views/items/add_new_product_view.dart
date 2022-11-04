import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm/services/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
            child: const Text("Cancel", style: TextStyle(color: Colors.black),),
            onPressed: () {
              productProvider.imagePath = null;
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                final imagePath = Provider.of<ProductProvider>(context, listen: false).imagePath;
                final serverTime = FieldValue.serverTimestamp();
                final productId = const Uuid().v4();
                productService.createNewProduct(
                  imagePath: imagePath,
                  name: productName.text,
                  price: int.parse(price.text,),
                  description: description.text,
                  createdTime: serverTime,
                  modifiedTime: serverTime,
                  creatorId: authProvider.currentUser!.id,
                  productId: productId,
                  likeCount: 0,
                );
                if(imagePath != null){
                  productService.uploadFileToCloud(imagePath, productId);
                  Provider.of<ProductProvider>(context, listen: false).imagePath = null;
                }
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
                child: productProvider.selectedImage ?? productProvider.defaultImage,
                
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
