import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/widgets/loading_animation.dart';

$showLoadingDialog(
  BuildContext context, [
  String arguments = 'Loading...',
]) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            LoadingWidget(
              color: AppTheme.primaryColor.shade500,
            ),
            const SizedBox(height: 20),
            Text(
              arguments,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'quicksand', fontSize: 16),
            ),
          ]),
        ),
      );
    },
  );
}
