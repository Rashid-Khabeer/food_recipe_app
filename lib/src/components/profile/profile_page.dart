import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/profile/recipe_count_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  final _countController = RecipeCountController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: 'My Profile',
        canPop: false,
        color: Colors.white,
      ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff314F7C).withOpacity(0.1),
                  blurRadius: 51,
                  offset: const Offset(0, 16),
                  spreadRadius: -16,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(children: [
              const Text('My Profile', style: kBoldW600f24Style),
              SimpleStreamBuilder<UserModel>.simpler(
                stream: UserFirestoreService().fetchOneStreamFirestore(
                  FirebaseAuthService.userId,
                ),
                context: context,
                builder: (user) {
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 44, 0, 16),
                      child: Row(children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppTheme.primaryColor.shade500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(107, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ]),
                    ),
                    Text(
                      user.name ?? '',
                      style: kBoldW600f24Style.copyWith(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                      child: Text(
                        user.bio ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.neutralColor.shade600,
                        ),
                      ),
                    ),
                    Text(
                      'Recipe',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.neutralColor.shade600,
                      ),
                    ),
                    RecipeCountWidget(countController: _countController),
                  ], crossAxisAlignment: CrossAxisAlignment.start);
                },
              ),
            ], crossAxisAlignment: CrossAxisAlignment.start),
          ),
        ),
        SimpleStreamBuilder<List<RecipeModel>>.simplerSliver(
          stream: RecipeFirestoreService().fetchSelectedStream(
            FirebaseAuthService.userId,
            'userId',
          ),
          context: context,
          builder: (data) {
            _countController.change(data.length);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  return const Text('Rashid');
                },
                childCount: data.length,
              ),
            );
          },
        ),
      ], controller: _scrollController),
    );
  }
}
