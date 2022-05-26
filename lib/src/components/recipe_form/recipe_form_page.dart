import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/components/recipe_form/ingredients_form.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_image_picker.dart';
import 'package:food_recipie_app/src/components/recipe_form/steps_form.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({Key? key}) : super(key: key);

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  late RecipeModel _recipe;
  final _scrollController = ScrollController();
  late RecipeImageController _imageController;
  late IngredientsController _ingredientsController;
  late StepsController _stepsController;

  @override
  void initState() {
    super.initState();
    _recipe = RecipeModel(
      name: '',
      imagesList: [],
      rating: 0,
      userId: '',
      category: '',
      cookingTime: '',
      ingredients: [IngredientsModel(name: '', quantity: '')],
      ratings: [],
      savedUsersIds: [],
      serves: '',
      steps: [StepsModel(step: '', image: '')],
      timestamp: Timestamp.now(),
    );
    _imageController = RecipeImageController(
      onChanged: (image) {},
    );
    _ingredientsController = IngredientsController(
      ingredients: _recipe.ingredients,
      onChanged: (value) => _recipe.ingredients = value,
    );
    _stepsController = StepsController(
      steps: _recipe.steps,
      onChanged: (value) => _recipe.steps = value,
    );
  }

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
          const Text('Edit Recipe', style: kBoldW600f24Style),
          RecipeImagePicker(imageController: _imageController),
          const AppTextField(
            hint: 'Recipe Name',
            label: 'Recipe Name',
          ),
          const SizedBox(height: 180 + 16 + 11),
          const SizedBox(height: 12),
          const Text('Ingredients', style: kBoldW600f24Style),
          const SizedBox(height: 16),
          IngredientsFormWidget(
            ingredientsController: _ingredientsController,
          ),
          const Text('Steps', style: kBoldW600f24Style),
          const SizedBox(height: 16),
          StepsFormWidget(stepsController: _stepsController),
          const SizedBox(height: 27),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Save Recipe'),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),
    );
  }
}
