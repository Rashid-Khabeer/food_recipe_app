import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static late SharedPreferences _sharedPreferences;
  static const _defaultLang = 'default_lang';

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> changeDefaultLang(String de) =>
      _sharedPreferences.setString(_defaultLang, de);

  String getDefaultLang() => _sharedPreferences.getString(_defaultLang) ?? 'en';
}
