import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({
    Key? key,
    required this.dataFunction,
    required this.title,
    required this.canPop,
  }) : super(key: key);

  final Stream<List<RecipeModel>> Function() dataFunction;
  final String title;
  final bool canPop;

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> with LocalizedStateMixin {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            widget.title == 'Saved recipes' ? lang.save_recipe : widget.title,
        canPop: widget.canPop,
        controller: _scrollController,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).padding.bottom,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title == 'Saved recipes'
                      ? lang.save_recipe
                      : widget.title,
                  style: kBoldW600f24Style,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
            SimpleStreamBuilder<List<RecipeModel>>.simplerSliver(
              stream: widget.dataFunction(),
              context: context,
              builder: (data) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      return RecipeWidget(
                        recipe: data[index],
                        padding: const EdgeInsets.only(bottom: 16),
                        withSaveButton: widget.title == 'Saved recipes',
                      );
                    },
                    childCount: data.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}