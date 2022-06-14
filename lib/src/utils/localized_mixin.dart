import 'package:flutter/widgets.dart';
import 'package:food_recipie_app/src/base/l10n/app_localizations.dart';

mixin LocalizedStateMixin<T extends StatefulWidget> on State<T> {
  late AppLocalizations lang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    lang = AppLocalizations.of(context)!;
  }
}
