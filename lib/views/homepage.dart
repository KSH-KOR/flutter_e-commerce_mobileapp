import 'package:finalterm/constant/execeptions.dart';
import 'package:finalterm/main.dart';
import 'package:finalterm/services/auth/auth_provider.dart';
import 'package:finalterm/views/itempage_view.dart';
import 'package:finalterm/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    return StreamBuilder(
      stream: _authProvider.getAuthStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return const ItemPageView();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went Wrong!"),
          );
        } else {
          return const LoginView();
          }
      },
    );
  }
}
