import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm/services/auth/model/auth_user.dart';
import 'package:finalterm/services/cloud/constants/product_field_name.dart';

import 'constants/auth_field_name.dart';

class FirebaseCloudAuthStorage {
  final users = FirebaseFirestore.instance.collection(authCollectionName);
  Future<void> createNewUser({
    required String? email,
    required String? name,
    required String? statusMessage,
    required String uid,
  }) async {
    final document = await users.doc(uid).set({
      userEmailFieldName: email,
      userNameFieldName: name,
      statusMessageFieldName: statusMessage,
      userIdFieldName: uid,
    });
  }

  Future<void> createNewFavoritedProduct(
      {required String uid, required String productId}) async {
    final document = await users
        .doc(uid)
        .collection(favoritedProductsCollecetionName)
        .doc(productId)
        .set({
      productIdFieldName: productId,
    });
  }

  Future<void> removeFavoriteProduct(
      {required String uid, required String productId}) async {
    final document = await users
        .doc(uid)
        .collection(favoritedProductsCollecetionName)
        .doc(productId)
        .delete();
  }

  Future<bool> isFavoriteProduct(
      {required String uid, required String productId}) async {
    final usersRef = users
        .doc(uid)
        .collection(favoritedProductsCollecetionName)
        .doc(productId);
    return await usersRef.get().then((docSnapshot) => docSnapshot.exists);
  }

  void addAuthToDatabase(final AuthUser user) {
    final usersRef = users.doc(user.id);
    usersRef.get().then((docSnapshot) async => {
          if (!docSnapshot.exists)
            {
              await createNewUser(
                email: user.email,
                name: user.name,
                statusMessage: user.statusMessage,
                uid: user.id,
              ),
            }else{
              log("already added"),
            }
        });
  }
}
