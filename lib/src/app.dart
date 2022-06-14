import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/app_controller.dart';
import 'package:food_recipie_app/src/base/data.dart';
import 'package:food_recipie_app/src/base/l10n/app_localizations.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/auth_page.dart';
import 'package:food_recipie_app/src/components/home/home_page.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/default_awaiter_behaviour.dart';
import 'package:reusables/reusables.dart';

final appController = AppController();

class FoodRecipeApp extends ControlledWidget<AppController> {
  FoodRecipeApp({Key? key}) : super(key: key, controller: appController);

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    Awaiter.defaultBehaviour = const DefaultAwaiterBehaviour();
    await AppData.initialize();
    await appController.initiate();
    await Firebase.initializeApp();
  }

  @override
  _FoodRecipeAppState createState() => _FoodRecipeAppState();
}

class _FoodRecipeAppState extends State<FoodRecipeApp> with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: widget.controller.locale,
      title: 'Recetas Unicas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.data,
      home: FirebaseAuthService.isLogin ? HomePage() : const AuthPage(),
      scrollBehavior: const CupertinoScrollBehavior(),
    );
  }
}
