import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/sheets.dart';
import 'package:food_recipie_app/src/components/home/home_page.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:reusables/reusables.dart';

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
      body: Stack(children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.authBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: const [0.0, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.black.withOpacity(0),
                Colors.black,
              ],
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Column(children: [
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
              onPressed: _submit,
              child: const Text('Log In'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                minimumSize: const Size(163, 66),
              ),
            ),
          ),
        ]),
      ], fit: StackFit.expand),
    );
  }

  void _submit() async {
    try {
      loginType? _type;
      await $showLoginBottomSheet(context, (type) => _type = type);
      if (_type == null) {
        return;
      }
      await Awaiter.process(
        future: _signIn(_type!),
        context: context,
        arguments: 'Signing in...',
      );
      Navigator.of(context).pop();
      AppNavigation.to(context, HomePage());
    } catch (e) {
      $showErrorDialog(context, e.toString());
    }
  }

  Future<void> _signIn(loginType type) async {
    try {
      late UserCredential _authUser;
      switch (type) {
        case loginType.google:
          _authUser = await FirebaseAuthService.signInWithGoogle();
          break;
        case loginType.facebook:
          _authUser = await FirebaseAuthService.signInWithFacebook();
          break;
      }
      final _service = UserFirestoreService();
      final _user = await _service.fetchOneFirestore(
        _authUser.user?.uid ?? '',
      );
      if (_user == null) {
        _service.insertFirestoreWithId(UserModel(
          email: _authUser.user?.email ?? '',
          name: _authUser.user?.displayName,
          bio: '',
          profilePicture: _authUser.user?.photoURL,
        )..id = _authUser.user?.uid);
      }
    } catch (_) {
      rethrow;
    }
  }
}
