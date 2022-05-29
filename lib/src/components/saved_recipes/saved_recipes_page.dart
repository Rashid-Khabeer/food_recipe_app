import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/components/saved_recipes/saved_recipe_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:food_recipie_app/src/widgets/simple_stream_builder.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({Key? key}) : super(key: key);

  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved recipes',
        canPop: false,
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
            const SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Saved Recipes', style: kBoldW600f24Style),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
            SimpleStreamBuilder<List<RecipeModel>>.simplerSliver(
              stream: RecipeFirestoreService().fetchSaved(),
              context: context,
              builder: (data) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      return SavedRecipeWidget(recipe: data[index]);
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
