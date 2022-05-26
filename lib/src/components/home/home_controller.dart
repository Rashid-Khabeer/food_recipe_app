import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    _views = [
      const Text('Home'),
      const Text('Saved'),
      const Text('Edit'),
      const Text('Profile'),
    ];
    _titles = [
      'Find best recipes for cooking',
      'Saved recipes',
      'Edit recipe',
      'My Profile',
    ];
  }

  final _scrollController = ScrollController();

  late List<Widget> _views;
  late List<String> _titles;
  var _currentIndex = 0;

  Widget get body => _views[_currentIndex];

  String get title => _titles[_currentIndex];

  int get currentIndex => _currentIndex;

  ScrollController get scrollController => _scrollController;

  void onTap(int value) {
    if (value == 2) {
      return;
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
    return true;
  }
}
