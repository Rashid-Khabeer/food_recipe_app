import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
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
        child: SimpleStreamBuilder<RecipeModel>.simpler(
          stream: RecipeFirestoreService().fetchOneStreamFirestore(
            widget.recipe.id!,
          ),
          context: context,
          builder: (recipe) {
            return Column(children: [
              Text(recipe.name),
            ]);
          },
        ),
      ),
    );
  }
}
