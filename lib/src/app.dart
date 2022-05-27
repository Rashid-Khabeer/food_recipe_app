import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/auth_page.dart';
import 'package:food_recipie_app/src/components/home/home_page.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/default_awaiter_behaviour.dart';
import 'package:reusables/reusables.dart';

class FoodRecipeApp extends StatelessWidget {
  const FoodRecipeApp({Key? key}) : super(key: key);

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    Awaiter.defaultBehaviour = const DefaultAwaiterBehaviour();
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recipe App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.data,
      home: FirebaseAuthService.isLogin ? HomePage() : const AuthPage(),
      scrollBehavior: const CupertinoScrollBehavior(),
    );
  }
}
