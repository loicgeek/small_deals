import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/src/auth/auth_service.dart';
import 'package:small_deals/src/auth/pages/login_page.dart';
import 'package:small_deals/src/products/pages/add_product_page.dart';
import 'package:small_deals/src/products/pages/home_products_page.dart';
import 'package:small_deals/src/user/pages/user_profile_page.dart';
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

  int currentPage = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    user = _authService.user!;
    pageController = PageController();
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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          HomeProductsPage(),
          AdproductPage(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
            pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Add",
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
