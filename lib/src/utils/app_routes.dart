import 'package:flutter/material.dart';

setRoot(
  BuildContext context,
  Widget page,
) {
  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page), (route) => false);
  });
}
