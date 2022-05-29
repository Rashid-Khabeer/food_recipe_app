import 'package:flutter/cupertino.dart';
import 'package:food_recipie_app/src/components/home_view/home_view.dart';
import 'package:food_recipie_app/src/components/profile/profile_page.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_form_page.dart';
import 'package:food_recipie_app/src/components/recipes/recipes_page.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    _views = [
      const HomeView(),
      RecipesPage(
        dataFunction: RecipeFirestoreService().fetchSaved,
        title: 'Saved recipes',
        canPop: false,
      ),
      const RecipeFormPage(),
      const ProfilePage(),
    ];
  }

  final _scrollController = ScrollController();

  late List<Widget> _views;
  var _currentIndex = 0;

  Widget get body => _views[_currentIndex];

  int get currentIndex => _currentIndex;

  ScrollController get scrollController => _scrollController;

  void onTap(int value) {
    // if (value == 2) {
    //   return;
    // }
    _currentIndex = value;
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    if (_currentIndex != 0) {
      _currentIndex = 0;
      notifyListeners();
      return false;
    }
    return true;
  }
}
