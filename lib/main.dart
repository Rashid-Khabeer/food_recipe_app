import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/app.dart';

void main() async {
  await FoodRecipeApp.initialize();
  runApp(FoodRecipeApp());
}
