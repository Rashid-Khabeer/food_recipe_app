import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_detail_page.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/blur_widget.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';
import 'package:food_recipie_app/src/widgets/show_rating_widget.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class RecipeWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: () {
          AppNavigation.to(context, RecipeDetailPage(recipe: recipe));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width ?? double.infinity,
              height: 180,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageWidget(url: recipe.imagesList.first),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    ShowRatingWidget(rating: recipe.rating),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlurWidget(
                        child: Text(
                          recipe.cookingTime,
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
            Text(recipe.name, style: kBoldW600f24Style),
            SizedBox(
              height: 32,
              child: SimpleStreamBuilder<UserModel>.simpler(
                context: context,
                stream: UserFirestoreService().fetchOneStreamFirestore(
                  recipe.userId,
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
                          noImageWidget: Icon(
                            CupertinoIcons.person,
                            size: 15,
                            color: AppTheme.primaryColor.shade500,
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
}
