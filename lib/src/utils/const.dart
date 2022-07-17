import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/data.dart';

const kBoldW600f24Style = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

const kBoldW600f16Style = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16,
  color: Colors.white,
);

enum loginType { google, facebook }

const kRecipeCategories = {
  'Breakfast': 'Breakfast',
  'Starters or Appetizers': 'Starters or Appetizers',
  'Main courses': 'Main courses',
  'Desserts': 'Desserts',
  'Meats': 'Meats',
  'Fish and Seafood': 'Fish and Seafood',
  'Salads': 'Salads',
  'Pasta': 'Pasta',
  'Rice': 'Rice',
  'Cakes': 'Cakes',
  'Spoon Plates': 'Spoon Plates',
  'For children': 'For children',
  'Vegetarian': 'Vegetarian',
  'Sauces': 'Sauces',
  'Doughs and breads': 'Doughs and breads',
};

const kRecipeCategoriesSpanish = {
  'Desayuno': 'Breakfast',
  'Entrantes o Aperitivos': 'Starters or Appetizers',
  'Platos Principales': 'Main courses',
  'Postres': 'Desserts',
  'Carnes': 'Meats',
  'Pescados y Mariscos': 'Fish and Seafood',
  'Ensaladas': 'Salads',
  'Pastas': 'Pasta',
  'Arroces': 'Rice',
  'Pasteles': 'Cakes',
  'Platos de Cuchara': 'Spoon Plates',
  'Para niños': 'For children',
  'Vegetariana': 'Vegetarian',
  'Salsas': 'Sauces',
  'Masas y panes': 'Doughs and breads',
};

List<String> getCategories() {
  return isEnglish()
      ? kRecipeCategories.keys.toList()
      : kRecipeCategoriesSpanish.keys.toList();
}

// Below functions are opposite,
// getCategoryKey return a value basically of above maps, which is a unique identifier used in db that's why called as key
// getCategoryValue return a key basically of above maps, find the value from the db key

String? getCategoryKey({required String category}) {
  return isEnglish()
      ? kRecipeCategories[category]
      : kRecipeCategoriesSpanish[category];
}

String getCategoryValue({required String category}) {
  var catMap = isEnglish()
      ? kRecipeCategories
      : kRecipeCategoriesSpanish;

  var index =
      catMap.values.toList().indexWhere((element) => element == category);
  var keys = catMap.keys.toList();
  return keys.isNotEmpty ? keys[index] : '';
}

bool isEnglish() {
  return AppData().getDefaultLang() == 'en';
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}