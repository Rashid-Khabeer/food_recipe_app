import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final RecipeModel recipe;

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: widget.recipe.name,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SimpleStreamBuilder<RecipeModel>.simpler(
          stream: RecipeFirestoreService().fetchOneStreamFirestore(
            widget.recipe.id!,
          ),
          context: context,
          builder: (recipe) {
            return Column(children: [
              Text(recipe.name, style: kBoldW600f24Style),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: NetworkImageWidget(
                    url: recipe.imagesList.first,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Image.asset(
                  AppAssets.star,
                  height: 12,
                  width: 12,
                  color: AppTheme.ratingColor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 7, 0),
                  child: Text(
                    recipe.rating.toStringAsFixed(1),
                    style: kBoldW600f24Style.copyWith(fontSize: 14),
                  ),
                ),
                Text(
                  '(${recipe.ratings.length} Reviews)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppTheme.neutralColor.shade400,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: SimpleStreamBuilder<UserModel>.simpler(
                  stream: UserFirestoreService().fetchOneStreamFirestore(
                    recipe.userId,
                  ),
                  context: context,
                  builder: (user) {
                    return Row(children: [
                      SizedBox(
                        width: 41,
                        height: 41,
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(TextSpan(
                          text: user.name ?? '',
                          style: kBoldW600f24Style,
                          children: [
                            TextSpan(
                              text: '\n${user.bio ?? ' '}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppTheme.neutralColor.shade600,
                              ),
                            )
                          ],
                        )),
                      ),
                    ]);
                  },
                ),
              ),
              const SizedBox(height: 15),
              _buildTitle('Ingredients', '${recipe.ingredients.length} items'),
              const SizedBox(height: 16),
              for (var ing in recipe.ingredients)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.neutralColor.shade100,
                  ),
                  child: Row(children: [
                    Expanded(child: Text(ing.name, style: kBoldW600f24Style)),
                    Text(
                      ing.quantity + ing.unit,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.neutralColor.shade400,
                      ),
                    ),
                  ]),
                ),
              const SizedBox(height: 12),
              _buildTitle('Steps', '${recipe.steps.length} steps'),
              const SizedBox(height: 16),
              ..._buildSteps(recipe),
            ], crossAxisAlignment: CrossAxisAlignment.start);
          },
        ),
      ),
    );
  }

  Widget _buildTitle(String text, String item) {
    return Row(children: [
      Expanded(
        child: Text(
          text,
          style: kBoldW600f24Style.copyWith(fontSize: 20),
        ),
      ),
      Text(
        item,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.neutralColor,
        ),
      ),
    ]);
  }

  List<Widget> _buildSteps(RecipeModel recipe) {
    var _list = <Widget>[];
    for (var i = 0; i < recipe.steps.length; i++) {
      var _step = recipe.steps[i];
      var _hasImage = _step.image?.isNotEmpty ?? false;
      _list.add(Container(
        padding: const EdgeInsets.fromLTRB(28, 14.71, 26, 21),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.neutralColor.shade100,
        ),
        child: Column(children: [
          Text('Step ${i + 1}', style: kBoldW600f24Style),
          Padding(
            padding: EdgeInsets.fromLTRB(
              19,
              12.5,
              37,
              _hasImage ? 16 : 0,
            ),
            child: Text(_step.step),
          ),
          if (_hasImage)
            SizedBox(
              width: double.infinity,
              height: 217,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetworkImageWidget(url: _step.image),
              ),
            ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ));
    }
    return _list;
  }
}
