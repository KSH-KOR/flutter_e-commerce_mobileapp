import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../cloud/firebase_cloud_product.dart';
import 'model/product.dart';

enum DropdownValue{
  asc, desc
}

class ProductProvider extends ChangeNotifier{
  final firebaseCloudProdcutStorage = FirebaseCloudProdcutStorage();
  final List<Product> _productList = [];
  final List<Product> _favoriteList = [];
  List<Product> get allProducts => _productList;
  List<Product> get favoritedProducts => _favoriteList;

  String? _imagePath;
  String? get imagePath => _imagePath;
  set imagePath(String? imagePath){
    _imagePath = imagePath;
    notifyListeners();
  }
  Image? get selectedImage => imagePath == null ? null : Image.file(File(imagePath!));

  final Image _defaultImage = Image.network("https://handong.edu/site/handong/res/img/logo.png");
  Image get defaultImage => _defaultImage;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  set isEditing(bool newVal){
    _isEditing = newVal;
    notifyListeners();
  } 
  void toggleEditingMode(){
    isEditing = !isEditing;
  }


  DropdownValue _dropdownValue = DropdownValue.asc;
  DropdownValue get dropdownValue => _dropdownValue;
  set dropdownValue(DropdownValue newVal){
    _dropdownValue = newVal;
    notifyListeners();
  }

  void toggleOrder(){
    _dropdownValue = _dropdownValue == DropdownValue.asc ? DropdownValue.desc : DropdownValue.asc;
    notifyListeners();
  }

  void addProduct(Product newProduct){
    _productList.add(newProduct);
    notifyListeners();
  }
  void deleteProduct(Product product){
    _productList.remove(product);
    firebaseCloudProdcutStorage.deleteProduct(docId: product.docId);
    notifyListeners();
  }

  void favoriteProduct(Product product){
    _favoriteList.add(product);
    product.likeCount++;
    firebaseCloudProdcutStorage.fetch(productId: product.productId, docId: product.docId, likeCount: product.likeCount);
    notifyListeners();
  }
  void cancelFavoriteProduct(Product product){
    _favoriteList.remove(product);
    product.likeCount--;
    firebaseCloudProdcutStorage.fetch(productId: product.productId, docId: product.docId, likeCount: product.likeCount);
    notifyListeners();
  }


}