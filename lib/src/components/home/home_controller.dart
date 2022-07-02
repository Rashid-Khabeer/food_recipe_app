import 'package:flutter/cupertino.dart';
import 'package:food_recipie_app/src/components/home_view/home_view.dart';
import 'package:food_recipie_app/src/components/profile/profile_page.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_form_page.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_search_page.dart';
import 'package:food_recipie_app/src/components/recipes/recipes_page.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    _views = [
      HomeView(onSearch: changeSearchView),
      RecipesPage(
        dataFunction: RecipeFirestoreService().fetchSaved,
        title: 'Saved recipes',
        canPop: false,
      ),
      const RecipeFormPage(),
      const ProfilePage(),
    ];
  }

  var _isSearchView = false;

  void changeSearchView() {
    _isSearchView = true;
    _views[0] = const RecipeSearchPage();
    notifyListeners();
  }

  final _scrollController = ScrollController();

  late List<Widget> _views;
  var _currentIndex = 0;

  Widget get body => _views[_currentIndex];

  int get currentIndex => _currentIndex;

  ScrollController get scrollController => _scrollController;

  void onTap(int value) {
    if (value == 0) {
      if (_isSearchView) {
        _views[0] = HomeView(onSearch: changeSearchView);
        _isSearchView = false;
      }
    }
    _currentIndex = value;
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    if (_currentIndex != 0) {
      _currentIndex = 0;
      notifyListeners();
      return false;
    }
    if (_isSearchView) {
      _views[0] = HomeView(onSearch: changeSearchView);
      _isSearchView = false;
      notifyListeners();
      return false;
    }
    return true;
  }
}
