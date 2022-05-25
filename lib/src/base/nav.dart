import 'package:flutter/material.dart';

abstract class AppNavigation {
  static Future<dynamic> to(BuildContext context, Widget page) async {
    return await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }

  static navigateRemoveUntil(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (BuildContext con) => page),
      (route) => false,
    );
  }
}
