import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/data.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/sheets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/auth_page.dart';
import 'package:food_recipie_app/src/components/profile/edit_profile_page.dart';
import 'package:food_recipie_app/src/components/profile/profile_recipe_widget.dart';
import 'package:food_recipie_app/src/components/profile/recipe_count_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with LocalizedStateMixin {
  final _scrollController = ScrollController();
  final _countController = RecipeCountController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: lang.my_profile,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang.my_profile, style: kBoldW600f24Style),
                  GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => const DefaultLangDialog()),
                    child: Wrap(
                      children: [
                        Text(AppData().getDefaultLang() == "en"
                            ? "English"
                            : "Spanish"),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ],
              ),
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
                          decoration: BoxDecoration(
                            color: AppTheme.neutralColor.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: NetworkImageWidget(
                              url: user.profilePicture,
                              noImageWidget: Icon(
                                CupertinoIcons.person,
                                size: 60,
                                color: AppTheme.primaryColor.shade500,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                AppNavigation.to(
                                  context,
                                  EditProfilePage(user: user),
                                );
                              },
                              child: Text(
                                lang.edit_profile,
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
                            const SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () async {
                                $showLoadingDialog(context, "Logging out...");
                                await FirebaseAuthService.logout();
                                Navigator.of(context).pop();
                                AppNavigation.to(
                                  context,
                                  const AuthPage(),
                                );
                              },
                              child: Text(
                                lang.logout,
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
                          ],
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
                      lang.recipe,
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
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                  return ProfileRecipeWidget(recipe: data[index]);
                },
                childCount: data.length,
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom),
        ),
      ], controller: _scrollController),
    );
  }
}
