import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';
import 'package:food_recipie_app/src/widgets/show_rating_widget.dart';

class ProfileRecipeWidget extends StatelessWidget {
  const ProfileRecipeWidget({
    Key? key,
    required this.recipe,
  }) : super(key: key);
  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 223,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: NetworkImageWidget(url: recipe.imagesList.first),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 111.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                stops: const [0.0, 1.0],
                begin: FractionalOffset.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.7),
                ],
                tileMode: TileMode.repeated,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 18),
          child: Column(children: [
            Row(children: [
              ShowRatingWidget(rating: recipe.rating),
              const Spacer(),
              TextButton(
                child: Image.asset(
                  AppAssets.menu,
                  width: 20,
                  height: 20,
                  color: AppTheme.primaryColor.shade500,
                ),
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(72),
                  ),
                  primary: AppTheme.primaryColor.shade500,
                ),
              ),
            ]),
            const Spacer(),
            Text(
              recipe.name,
              style: kBoldW600f24Style.copyWith(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${recipe.ingredients.length} Ingredients | ${recipe.cookingTime}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ], fit: StackFit.expand),
    );
  }
}
