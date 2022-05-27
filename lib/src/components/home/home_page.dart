import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/components/home/home_controller.dart';
import 'package:reusables/reusables.dart';

class HomePage extends ControlledWidget<HomeController> {
  HomePage({
    Key? key,
  }) : super(key: key, controller: HomeController());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.controller.onWillPop,
      child: Scaffold(
        body: widget.controller.body,
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          notchMargin: 6,
          elevation: 8,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: CupertinoTabBar(
            height: 72,
            currentIndex: widget.controller.currentIndex,
            onTap: widget.controller.onTap,
            backgroundColor: Colors.white,
            items: [
              _buildBottom(
                index: 0,
                main: AppAssets.homeMain,
                image: AppAssets.home,
              ),
              _buildBottom(
                index: 1,
                main: AppAssets.savedMain,
                image: AppAssets.saved,
              ),
              _buildBottom(
                index: 2,
                main: AppAssets.add,
                image: AppAssets.add,
              ),
              _buildBottom(
                index: 3,
                main: AppAssets.profileMain,
                image: AppAssets.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottom({
    required int index,
    required String main,
    required String image,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        widget.controller.currentIndex == index ? main : image,
        width: 20,
        height: 20,
      ),
    );
  }
}
