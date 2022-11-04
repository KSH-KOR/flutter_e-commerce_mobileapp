import 'package:finalterm/services/auth/auth_provider.dart';
import 'package:finalterm/services/product/product_provider.dart';
import 'package:finalterm/views/homepage.dart';
import 'package:finalterm/views/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constant/routes.dart';
import 'firebase_options.dart';
import 'views/items/product_detail_view.dart';
import 'views/items/add_new_product_view.dart';
import 'views/items/wishlist_view.dart';
import 'views/mypage_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Midterm 김신후 21900136',
        initialRoute: homepageRoute,
        routes: {
          detailRoute: (BuildContext context) => const DetailView(),
          homepageRoute: (BuildContext context) => const HomePage(),
          myPageRoute: (BuildContext context) => const MyPageView(),
          addNewProductRoute: (BuildContext context) => AddNewProductView(),
          profileRoute: (BuildContext context) => const ProfileView(),
          wishListRoute: (BuildContext context) =>const WishListView(),
        },
      ),
    ),
  );
}