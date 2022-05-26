import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

part 'button_theme.dart';

part 'app_colors.dart';

abstract class AppTheme {
  AppTheme._();

  static MaterialColor get primaryColor => _primaryColor;

  static MaterialColor get neutralColor => _neutralColor;

  static MaterialColor get secondaryColor => _secondaryColor;

  static Color get backgroundColor => const Color(0xffE5E5E5);

  static Color get ratingColor => const Color(0xffFFB661);

  static Color get errorColor => const Color(0xffEE1133);

  static Color get successColor => const Color(0xff31B057);

  static final data = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: _primaryColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: _ColorProperty(
          _primaryColor.shade500,
          _neutralColor.shade200,
        ),
        overlayColor: _MaterialStateProperty(_primaryColor.shade800),
        foregroundColor: _ColorProperty(
          _neutralColor.shade50,
          _neutralColor.shade500,
        ),
        elevation: const _MaterialStateProperty(0),
        padding:
            const _MaterialStateProperty(EdgeInsets.symmetric(vertical: 16)),
        minimumSize: const _MaterialStateProperty(Size(double.infinity, 0)),
        textStyle: const _MaterialStateProperty(kBoldW600f24Style),
        shape: const _MaterialStateProperty(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        )),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: _ColorProperty(
          Colors.white,
          _neutralColor.shade200,
        ),
        foregroundColor: _ColorProperty(
          _neutralColor.shade500,
          _neutralColor.shade500,
        ),
        overlayColor: _MaterialStateProperty(_primaryColor.shade100),
        side: _MaterialStateProperty(BorderSide(color: _primaryColor.shade500)),
        elevation: const _MaterialStateProperty(0),
        padding:
            const _MaterialStateProperty(EdgeInsets.symmetric(vertical: 16)),
        minimumSize: const _MaterialStateProperty(Size(double.infinity, 0)),
        textStyle: const _MaterialStateProperty(kBoldW600f24Style),
        shape: const _MaterialStateProperty(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        )),
      ),
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: _primaryColor,
    ),
    appBarTheme: const AppBarTheme(elevation: 0, color: Colors.white),
    primaryColor: _primaryColor,
    backgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _primaryColor),
  );
}
