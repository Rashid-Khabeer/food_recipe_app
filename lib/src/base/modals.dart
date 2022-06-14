import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/widgets/loading_animation.dart';

$showSnackBar(BuildContext context, String content) {
  final _messenger = ScaffoldMessenger.of(context);
  _messenger.clearSnackBars();
  _messenger.showSnackBar(SnackBar(content: Text(content)));
}

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
              size: 30,
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

$showErrorDialog(
  BuildContext context,
  dynamic error, [
  String heading = '',
]) async {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (heading.isNotEmpty)
                Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool> $showConfirmationDialog(
  BuildContext context,
  String content,
) async {
  final _result = await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 15),
              child: Text(
                content,
                style: const TextStyle(fontFamily: 'quicksand', fontSize: 13),
              ),
            ),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 35),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 35),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ]),
          ],
        ),
      );
    },
  );
  return _result ?? false;
}

///TODO pick localization strings