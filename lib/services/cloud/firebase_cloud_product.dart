import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm/services/product/model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'constants/product_field_name.dart';

class FirebaseCloudProdcutStorage {
  final products = FirebaseFirestore.instance.collection(productCollectionName);
  final storageRef = FirebaseStorage.instance.ref();

  Stream<Iterable<Product>> allProducts({bool isDescending = true}) {
    final allProducts = products
        .orderBy(productPriceFieldName, descending: isDescending)
        .where(productIdFieldName)
        .snapshots()
        .map((event) => event.docs.map((doc) => Product.fromSnapshot(doc)));
    return allProducts;
  }

  Future<void> createNewProduct({
    String? imagePath,
    required String name,
    required String price,
    required String description,
    required int likeCount,
    required String creatorId,
    required String productId,
    required FieldValue createdTime,
    required FieldValue modifiedTime,
  }) async {
    final document = await products.add({
      imagePathFieldName: imagePath,
      productNameFieldName: name,
      productPriceFieldName: price,
      productDescriptionFieldName: description,
      likedFieldName: likeCount,
      creatorIdFieldName: creatorId,
      productIdFieldName: productId,
      createdTimeFieldName: createdTime,
      modifiedTimeFieldName: modifiedTime,
    });
    final fetchedProduct = await document.get();
    log("created");
    /*
    return Product(
      imagePath: imagePath,
      name: name,
      price: price,
      description: description,
      likeCount: likeCount,
      creatorId: creatorId,
      productId: productId,
      createdTime: createdTime,
      modifiedTime: modifiedTime,
      docId: fetchedProduct.id,
    );*/
  }

  void deleteProduct({required String docId}){
    products.doc(docId).delete();
  }

  Future<void> fetch({
    String? imagePath,
    String? name,
    String? price,
    String? description,
    int? likeCount,
    String? modifiedTime,

    required String productId,
    required String docId,
  }) async {
    final snapshot = await products.doc(docId).get();
    Map<String, dynamic> product = snapshot.data() as Map<String, dynamic>;
    await products.doc(docId).update({
        imagePathFieldName: imagePath ?? product[imagePathFieldName],
        productNameFieldName: name ?? product[productNameFieldName],
        productPriceFieldName: price ?? product[productPriceFieldName],
        productDescriptionFieldName: description ?? product[productDescriptionFieldName],
        likedFieldName: likeCount ?? product[likedFieldName],
        modifiedTimeFieldName: modifiedTime ?? product[modifiedTimeFieldName],
      });
  }

  Future<void> uploadFileToCloud(String path, String? subRef) async {
    final targetRef = subRef == null ? storageRef : storageRef.child(subRef);
    final file = File(path);
    try {
      await targetRef.putFile(file);
    } on FirebaseException catch (e) {
      log("cannot uploaded error msg:${e.code}");
    }
  }
}
