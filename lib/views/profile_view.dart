import 'package:finalterm/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            authProvider.signout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(homepageRoute, (route) => false);
          },
          icon: const Icon(Icons.logout),
        ),
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: authProvider.getProfileImage(),
                  ),
                ),
                Text(authProvider.currentUser!.id),
                Text(authProvider.currentUser!.email ?? "Anonymous"),
                Text(authProvider.currentUser!.name ?? "Anonymous"),
                Text(authProvider.currentUser!.statusMessage ?? "Anonymous"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
