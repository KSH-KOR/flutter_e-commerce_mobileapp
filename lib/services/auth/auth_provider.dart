

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../constant/execeptions.dart';
import '../cloud/firebase_cloud_auth_user.dart';
import 'model/auth_user.dart';


class AuthProvider extends ChangeNotifier{
  final firebaseCloudAuthStorage = FirebaseCloudAuthStorage();
  final googleSignIn = GoogleSignIn();

  final String _defaultImageURL = "https://handong.edu/site/handong/res/img/logo.png";
  String get defaultImageURL => _defaultImageURL;

  Image getProfileImage(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? url = AuthUser.fromFirebase(user).photoURL;
      return Image.network(url ?? defaultImageURL);
    } else {
      log("someting went wrong. could not find auth");
      return Image.network(defaultImageURL);
    }
  }

  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  Future googleLogIn() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null){
      throw GoogleSignInExeception;
    } 

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    addAuthToDatabase();
    notifyListeners();
  }

  Future anonymouslogIn() async {
    await FirebaseAuth.instance.signInAnonymously();
    addAuthToDatabase();
    notifyListeners();
  }

  Future<void> signout() async {
    final AuthUser? user = currentUser;
    if (user != null) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {
        throw GenericAuthException();
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
    notifyListeners();
  }

  Future<int> toggleFavoriteProduct({required String productId}) async {
    final AuthUser? user = currentUser;
    if(user == null) return -1;
    
    if(!await firebaseCloudAuthStorage.isFavoriteProduct(uid: user.id, productId: productId)){
      addFavoriteProduct(productId: productId);
      log("addFavoriteProduct");
      return 1;
    } else{
      cancelFavoriteProduct(productId: productId);
       log("cancelFavoriteProduct");
      return 0;
    }
    
  }

  Future<bool> addFavoriteProduct({required String productId}) async {
    final AuthUser? user = currentUser;
    if(user == null) return false;
    if(await firebaseCloudAuthStorage.isFavoriteProduct(uid: user.id, productId: productId)) return false;
    
    final temp = user.favoritedProducts.toList();
    temp.add(productId);
    user.favoritedProducts = temp;
    firebaseCloudAuthStorage.createNewFavoritedProduct(uid: user.id, productId: productId);
    return true;
  }

  void cancelFavoriteProduct({required String productId}){
    final AuthUser? user = currentUser;
    if(user != null){
      final temp = user.favoritedProducts.toList();
      temp.remove(productId);
      user.favoritedProducts = temp;
      firebaseCloudAuthStorage.removeFavoriteProduct(uid: user.id, productId: productId);
    } else{
      throw UserNotLoggedInAuthException;
    }
  }

  void addAuthToDatabase(){
    final AuthUser? user = currentUser;
    if(user != null){
      firebaseCloudAuthStorage.addAuthToDatabase(user);
    }
  }


  Stream<User?> getAuthStateChanges() => FirebaseAuth.instance.authStateChanges();
}