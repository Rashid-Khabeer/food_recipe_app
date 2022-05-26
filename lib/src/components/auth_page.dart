import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/components/home/home_controller.dart';
import 'package:food_recipie_app/src/components/home/home_page.dart';
import 'package:food_recipie_app/src/utils/const.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final _padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.authBackground),
            fit: BoxFit.cover,
          ),
          // gradient: LinearGradient(
          //   stops: const [0.0, 1.0],
          //   begin: FractionalOffset.topCenter,
          //   end: FractionalOffset.bottomCenter,
          //   tileMode: TileMode.repeated,
          //   colors: [
          //     Colors.red,
          //     Colors.black,
          //   ],
          // ),
        ),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: _padding.top + 36),
            child: const Text(
              'Reciats Unicas',
              style: kBoldW600f16Style,
            ),
          ),
          const Spacer(),
          Text(
            "Let's",
            style: kBoldW600f16Style.copyWith(fontSize: 56),
          ),
          Text(
            'Cooking',
            style: kBoldW600f16Style.copyWith(fontSize: 56),
          ),
          const SizedBox(height: 24),
          const Text(
            'Find the best food recipes',
            style: kBoldW600f16Style,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: _padding.bottom + 40, top: 44),
            child: ElevatedButton(
              onPressed: () {
                AppNavigation.to(
                  context,
                  HomePage(homeController: HomeController()),
                );
              },
              child: const Text('Login In'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                minimumSize: const Size(163, 66),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
