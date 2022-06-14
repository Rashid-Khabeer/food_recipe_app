import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/data.dart';

class AppController extends ChangeNotifier {
  void reloadApp() => notifyListeners();
  late Locale locale;

  Future<void> initiate() async {
    locale = Locale.fromSubtags(languageCode: AppData().getDefaultLang());
  }

  void changeLocale(String lang) async {
    await AppData().changeDefaultLang(lang);
    locale = Locale(lang);
    notifyListeners();
  }
}
