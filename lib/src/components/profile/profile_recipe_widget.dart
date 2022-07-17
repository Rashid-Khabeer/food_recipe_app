import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_form_page.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_detail_page.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';
import 'package:food_recipie_app/src/widgets/show_rating_widget.dart';

class ProfileRecipeWidget extends StatefulWidget {
  const ProfileRecipeWidget({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final RecipeModel recipe;

  @override
  State<ProfileRecipeWidget> createState() => _ProfileRecipeWidgetState();
}

class _ProfileRecipeWidgetState extends State<ProfileRecipeWidget>
    with LocalizedStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigation.to(
        context,
        RecipeDetailPage(recipe: widget.recipe),
      ),
      child: Container(
        height: 223,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: NetworkImageWidget(url: widget.recipe.imagesList.first),
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
                ShowRatingWidget(rating: widget.recipe.rating),
                const Spacer(),
                TextButton(
                  child: PopupMenuButton(
                    child: Image.asset(
                      AppAssets.menu,
                      width: 20,
                      height: 20,
                      color: AppTheme.primaryColor.shade500,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          AppNavigation.to(
                            context,
                            RecipeFormPage(recipeModel: widget.recipe),
                          );
                          break;
                        case 1:
                          _deleteAction();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Text(lang.edit),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text(lang.delete),
                      ),
                    ],
                  ),
                  onPressed: null,
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
                isEnglish()
                    ? widget.recipe.englishName
                    : widget.recipe.spanishName,
                style: kBoldW600f24Style.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${widget.recipe.ingredients.length} ${lang.ingredient}(s) | ${widget.recipe.cookingTime}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ], crossAxisAlignment: CrossAxisAlignment.start),
          ),
        ], fit: StackFit.expand),
      ),
    );
  }

  _deleteAction() async {
    if (!(await $showConfirmationDialog(
      context,
      lang.sure_to_delete,
    ))) {
      return;
    }
    try {
      // $showLoadingDialog(context, 'Deleting...');
      await RecipeFirestoreService().deleteFirestore(widget.recipe.id ?? '');
      await RecipeFirestoreService().updateCreatorAverage(userId: widget.recipe.userId);
      // Navigator.pop(context);
    } catch (_) {
      $showSnackBar(context, 'Delete failed!');
      // Navigator.of(context).pop();
    }
  }
}
