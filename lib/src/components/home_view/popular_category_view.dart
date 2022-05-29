import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class PopularCategoryView extends StatefulWidget {
  const PopularCategoryView({Key? key}) : super(key: key);

  @override
  _PopularCategoryViewState createState() => _PopularCategoryViewState();
}

class _PopularCategoryViewState extends State<PopularCategoryView> {
  var _selected = '';

  @override
  void initState() {
    super.initState();
    _selected = kRecipeCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 34,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, i) {
            final _item = kRecipeCategories[i];
            var _isSelected = _item == _selected;
            return GestureDetector(
              onTap: () {
                _selected = _item;
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                decoration: BoxDecoration(
                  color: _isSelected
                      ? AppTheme.primaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _item,
                  style: TextStyle(
                    color: _isSelected
                        ? Colors.white
                        : AppTheme.primaryColor.shade300,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
          itemCount: kRecipeCategories.length,
        ),
      ),
      const SizedBox(height: 16),
      SimpleStreamBuilder<List<RecipeModel>>.simpler(
        stream: RecipeFirestoreService().fetchByCategory(_selected),
        context: context,
        builder: (data) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return RecipeWidget(
                recipe: data[i],
                width: 280,
                padding: const EdgeInsets.only(right: 16),
              );
            },
            itemCount: data.length,
          );
        },
      ),
    ]);
  }
}
