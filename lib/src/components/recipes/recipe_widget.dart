import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_detail_page.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/blur_widget.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';
import 'package:food_recipie_app/src/widgets/show_rating_widget.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class RecipeWidget extends StatefulWidget {
  const RecipeWidget({
    Key? key,
    required this.recipe,
    this.width,
    required this.padding,
  }) : super(key: key);

  final RecipeModel recipe;
  final double? width;
  final EdgeInsets padding;

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  final _userId = FirebaseAuthService.userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: GestureDetector(
        onTap: () {
          AppNavigation.to(context, RecipeDetailPage(recipe: widget.recipe));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.width ?? double.infinity,
              height: 180,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      NetworkImageWidget(url: widget.recipe.imagesList.first),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Row(children: [
                      ShowRatingWidget(rating: widget.recipe.rating),
                      const Spacer(),
                      TextButton(
                        onPressed: _bookMarkAction,
                        child: Image.asset(
                          AppAssets.saved,
                          color: widget.recipe.savedUsersIds.contains(_userId)
                              ? AppTheme.primaryColor.shade500
                              : const Color(0xff130F26),
                          height: 14.61,
                          width: 18.22,
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(32, 32),
                          primary: AppTheme.primaryColor.shade500,
                          backgroundColor: Colors.white,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 5,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ]),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlurWidget(
                        child: Text(
                          widget.recipe.cookingTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ], crossAxisAlignment: CrossAxisAlignment.start),
                ),
              ], fit: StackFit.expand),
            ),
            Text(widget.recipe.name, style: kBoldW600f24Style),
            SizedBox(
              height: 32,
              child: SimpleStreamBuilder<UserModel>.simpler(
                context: context,
                stream: UserFirestoreService().fetchOneStreamFirestore(
                  widget.recipe.userId,
                ),
                builder: (user) {
                  return Row(children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: NetworkImageWidget(
                          url: user.profilePicture,
                          noImageWidget: Container(
                            color: AppTheme.neutralColor.shade100,
                            child: Icon(
                              CupertinoIcons.person,
                              size: 15,
                              color: AppTheme.primaryColor.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.neutralColor.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookMarkAction() async {
    try {
      if (widget.recipe.savedUsersIds.contains(_userId)) {
        widget.recipe.savedUsersIds.remove(_userId);
      } else {
        widget.recipe.savedUsersIds.add(_userId);
      }
      await RecipeFirestoreService().updateFirestore(widget.recipe);
    } catch (_) {}
  }
}
