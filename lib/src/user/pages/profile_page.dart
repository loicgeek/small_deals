import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:small_deals/src/user/pages/user_products.dart';
import 'package:small_deals/src/user/pages/user_profile_page.dart';
import 'package:small_deals/src/utils/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              tabs: [
                Tab(
                  text: "My Profile",
                ),
                Tab(
                  text: "My Products",
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UserProfilePage(),
                  UserProducts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
