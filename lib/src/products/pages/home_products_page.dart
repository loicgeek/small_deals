import 'package:flutter/material.dart';

class HomeProductsPage extends StatefulWidget {
  const HomeProductsPage({Key? key}) : super(key: key);

  @override
  _HomeProductsPageState createState() => _HomeProductsPageState();
}

class _HomeProductsPageState extends State<HomeProductsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("HomeProductsPage"),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
