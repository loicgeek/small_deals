import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/app_initialization_page.dart';
import 'package:small_deals/src/auth/pages/login_page.dart';
import 'package:small_deals/src/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Small Deals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: AppColors.createMaterialColor(AppColors.primary),
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: AppColors.primary,
        ),
      ),
      home: const AppInitializationPage(),
    );
  }
}
