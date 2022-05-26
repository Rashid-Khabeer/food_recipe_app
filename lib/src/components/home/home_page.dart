import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/components/home/home_controller.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:reusables/reusables.dart';

class HomePage extends ControlledWidget<HomeController> {
  const HomePage({
    Key? key,
    required this.homeController,
  }) : super(key: key, controller: homeController);

  final HomeController homeController;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.controller.onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          controller: widget.controller.scrollController,
          canPop: false,
          title: widget.controller.title,
        ),
        body: SingleChildScrollView(
          controller: widget.controller.scrollController,
        ),
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
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
