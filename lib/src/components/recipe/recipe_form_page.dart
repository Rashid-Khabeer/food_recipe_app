import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({Key? key}) : super(key: key);

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        canPop: false,
        title: 'Edit recipe',
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(children: [
          const Text('Edit Recipe', style: boldW600f24Style),
          Container(
            height: 200,
            margin: const EdgeInsets.fromLTRB(0, 24, 0, 20),
          ),
          const AppTextField(
            hint: 'Rashid',
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Save Recipe'),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),
    );
  }
}
