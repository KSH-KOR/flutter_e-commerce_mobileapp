import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../cloud/constants/auth_field_name.dart';


class AuthUser {
  final String id;
  final String? email;
  final String? statusMessage;
  final String? name;
  final bool isAnonymous;
  final String? photoURL;
  List<String> favoritedProducts;
  AuthUser({
    required this.isAnonymous,
    required this.id,
    required this.favoritedProducts,
    required this.photoURL, 
    this.name,
    this.email, 
    this.statusMessage, 
  });

  AuthUser.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()[userNameFieldName],
        email = snapshot.data()[userEmailFieldName],
        id = snapshot.data()[userIdFieldName],
        statusMessage = snapshot.data()[statusMessageFieldName],
        isAnonymous = snapshot.data()[userNameFieldName] == null || snapshot.data()[userEmailFieldName] == null,
        photoURL = snapshot.data()[userProfileURLFieldName],
        favoritedProducts = snapshot
            .data()[favoritedProductsCollecetionName]
            .getDocuments()
            .then((collectionSnapshot) {
          return collectionSnapshot.documents.toList();
        });


  // create authuser from firebase user
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid, 
        isAnonymous: user.isAnonymous,
        name: user.displayName,
        statusMessage: "I promise to take the test honestly before GOD.",
        email: user.email,
        favoritedProducts: const [],
        photoURL: user.photoURL,
      );
}