import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipe/recipe_form_page.dart';
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
      home: const RecipeFormPage(),
      scrollBehavior: const CupertinoScrollBehavior(),
    );
  }
}
