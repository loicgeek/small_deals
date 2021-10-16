import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/src/auth/auth_service.dart';
import 'package:small_deals/src/auth/pages/login_page.dart';
import 'package:small_deals/src/utils/app_colors.dart';
import 'package:small_deals/src/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  late AuthService _authService;
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    user = _authService.user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Small Deals"),
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.logout();
              setRoot(context, LoginPage());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          RichText(
            text: TextSpan(
              text: " Welcome ",
              style: TextStyle(
                fontSize: 37,
                fontWeight: FontWeight.w700,
                letterSpacing: .2,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "${user.email} ",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 37,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
