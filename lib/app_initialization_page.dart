import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/home_page.dart';
import 'package:small_deals/src/auth/pages/login_page.dart';
import 'package:small_deals/src/utils/app_routes.dart';

class AppInitializationPage extends StatefulWidget {
  const AppInitializationPage({Key? key}) : super(key: key);

  @override
  _AppInitializationPageState createState() => _AppInitializationPageState();
}

class _AppInitializationPageState extends State<AppInitializationPage> {
  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  checkAuthState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setRoot(context, HomePage());
    } else {
      setRoot(context, LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
