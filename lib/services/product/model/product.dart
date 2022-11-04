import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm/services/cloud/constants/product_field_name.dart';
import 'package:flutter/material.dart';

class Product {
  
   String name;
   int price;
   String description;
  int likeCount;
  final String creatorId;
  final String productId;
  final Timestamp? createdTime;
   Timestamp? modifiedTime;
   String? imagePath;

  final String docId;

  Product({
    this.imagePath,
    required this.name,
    required this.price, 
    required this.description, 
    required this.likeCount, 
    required this.creatorId, 
    required this.productId, 
    required this.createdTime, 
    required this.modifiedTime, 
    required this.docId, 
  });

  Product.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()[productNameFieldName],
        price = snapshot.data()[productPriceFieldName],
        description = snapshot.data()[productDescriptionFieldName],
        likeCount = snapshot.data()[likedFieldName],
        creatorId = snapshot.data()[creatorIdFieldName],
        productId = snapshot.data()[productIdFieldName],
        createdTime = snapshot.data()[createdTimeFieldName] as Timestamp?,
        modifiedTime = snapshot.data()[modifiedTimeFieldName] as Timestamp?,
        imagePath = snapshot.data()[imagePathFieldName], 
        docId = snapshot.id;

  Image? selectedImaged(){
    return imagePath != null ? Image.file(File(imagePath!)) : null;
  }

}