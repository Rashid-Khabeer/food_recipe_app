import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/home/home_page.dart';
import 'package:food_recipie_app/src/components/recipe_form/ingredients_form.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_form_view.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_image_picker.dart';
import 'package:food_recipie_app/src/components/recipe_form/steps_form.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/services/firebase_storage_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:reusables/reusables.dart';
import 'package:translator/translator.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({
    Key? key,
    this.recipeModel,
  }) : super(key: key);

  final RecipeModel? recipeModel;

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> with LocalizedStateMixin {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;
  var _isEdit = false;

  String? _mainImage;
  late RecipeModel _recipe;
  late RecipeImageController _imageController;
  late IngredientsController _ingredientsController;
  late StepsController _stepsController;

  final translator = GoogleTranslator();

  Future<String> translateText({
    required String input,
    required String lang,
  }) async {
    String text = '';
    await translator
        .translate(input, to: lang)
        .then((value) => text = value.text);
    return text;
  }

  String capitalize({required String text}) {
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<RecipeModel> translateRecipe({required RecipeModel recipe}) async {
    recipe.name = capitalize(text: recipe.name);
    recipe.spanishName = await translateText(
      input: recipe.name,
      lang: 'es',
    );
    recipe.englishName = await translateText(
      input: recipe.name,
      lang: 'en',
    );

    recipe.englishIngredients = recipe.ingredients;
    recipe.spanishIngredients = recipe.ingredients;
    recipe.englishSteps = recipe.steps;
    recipe.spanishSteps = recipe.steps;

    for (var i = 0; i < recipe.ingredients.length; i++) {
      recipe.ingredients[i].name =
          capitalize(text: recipe.ingredients[i].name);
      var name = recipe.ingredients[i].name;
      print("------------------------");
      print(recipe.ingredients[i].name);
      recipe.englishIngredients[i].name = await translateText(
        input: name,
        lang: 'en',
      );
      print("==================");
      print(recipe.ingredients[i].name);
      print(recipe.englishIngredients[i].name);


      print("------------------------");
      print(recipe.ingredients[i].name);
      recipe.spanishIngredients[i].name = await translateText(
        input: name,
        lang: 'es',
      );
      print("==================");
      print(recipe.ingredients[i].name);
      print(recipe.spanishIngredients[i].name);
    }
    for (var i = 0; i < recipe.steps.length; i++) {
      recipe.steps[i].step =
          capitalize(text: recipe.steps[i].step);
      recipe.englishSteps[i].step = await translateText(
        input: recipe.steps[i].step,
        lang: 'en',
      );
      recipe.spanishSteps[i].step = await translateText(
        input: recipe.steps[i].step,
        lang: 'es',
      );
    }
    return recipe;
  }

  @override
  void initState() {
    super.initState();
    _isEdit = widget.recipeModel != null;
    _recipe = widget.recipeModel ??
        RecipeModel(
          name: '',
          spanishName: '',
          englishName: '',
          imagesList: [],
          rating: 0,
          userId: FirebaseAuthService.userId,
          category: [],
          cookingTime: '0 H',
          ingredients: [IngredientsModel(name: '', quantity: '', unit: null)],
          spanishIngredients: [],
          englishIngredients: [],
          ratings: [],
          savedUsersIds: [],
          serves: '1',
          steps: [StepsModel(step: '', image: '')],
          spanishSteps: [],
          englishSteps: [],
          timestamp: Timestamp.now(),
        );
    _imageController = RecipeImageController(
      url: _recipe.imagesList.isEmpty ? null : _recipe.imagesList.first,
      onChanged: (image) => _mainImage = image,
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
        canPop: _isEdit,
        title: lang.edit_recipe,
      ),
      body: Form(
        autovalidateMode: _autoValidateMode,
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(children: [
            Text(lang.edit_recipe, style: kBoldW600f24Style),
            RecipeImagePicker(imageController: _imageController),
            AppTextField(
              hint: lang.recipe_name,
              label: lang.recipe_name,
              value: _recipe.name,
              validator: InputValidator.required(
                message: lang.name_required,
              ),
              onSaved: (value) => _recipe.name = value ?? '',
            ),
            const SizedBox(height: 16),
            _buildTile(
              icon: AppAssets.friends,
              title: lang.serves,
              text: _recipe.serves,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
              child: _buildTile(
                icon: AppAssets.time,
                title: lang.cooking_time,
                text: _recipe.cookingTime,
              ),
            ),
            _buildTile(
              icon: AppAssets.friends,
              title: lang.category,
              text: _recipe.category.isNotEmpty
                  ? getCategoryValue(category: _recipe.category.first) +
                      (_recipe.category.length > 1
                              ? " +" + (_recipe.category.length - 1).toString()
                              : "")
                          .toString()
                  : "",
            ),
            const SizedBox(height: 12),
            Text(lang.ingredient + "s", style: kBoldW600f24Style),
            const SizedBox(height: 16),
            IngredientsFormWidget(
              ingredientsController: _ingredientsController,
            ),
            Text(lang.steps, style: kBoldW600f24Style),
            const SizedBox(height: 16),
            StepsFormWidget(stepsController: _stepsController),
            const SizedBox(height: 27),
            ElevatedButton(
              onPressed: _submit,
              child: Text(lang.save_recipe),
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
    );
  }

  Widget _buildTile({
    required String icon,
    required String title,
    required String text,
  }) {
    return GestureDetector(
      onTap: () async {
        await AppNavigation.to(
          context,
          RecipeFormView(
            onChanged: (value) {
              _recipe = value;
              setState(() {});
            },
            recipe: _recipe,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
        decoration: BoxDecoration(
          color: AppTheme.neutralColor.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff314F7C).withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: -16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Image.asset(
              icon,
              width: 15,
              height: 15,
              color: AppTheme.primaryColor.shade500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: kBoldW600f16Style.copyWith(color: Colors.black),
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppTheme.neutralColor.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(AppAssets.next, width: 24, height: 24),
        ]),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
      setState(() {});
      return;
    }
    if (!_isEdit) {
      if (_mainImage?.isEmpty ?? true) {
        $showSnackBar(context, 'Main photo is required');
        return;
      }
    }
    if (_recipe.serves.isEmpty) {
      $showSnackBar(context, 'Serve is required');
      return;
    }
    if (_recipe.ingredients.isEmpty) {
      $showSnackBar(context, 'Ingredients are required');
      return;
    }
    if (_recipe.steps.isEmpty) {
      $showSnackBar(context, 'Steps are required');
      return;
    }
    if (_recipe.cookingTime.isEmpty) {
      $showSnackBar(context, 'Cooking time is required');
      return;
    }
    if (_recipe.category.isEmpty) {
      $showSnackBar(context, 'At least one category is required');
      return;
    }
    _formKey.currentState!.save();
    try {
      await Awaiter.process(
        future: _isEdit ? _update() : _save(),
        context: context,
        arguments: 'Saving, Please wait this will take a moment...',
      );
      if (_isEdit) {
        $showSnackBar(context, 'Recipe Updated!');
        Navigator.of(context).pop();
      } else {
        $showSnackBar(context, 'Recipe Added!');
        AppNavigation.to(context, HomePage());
      }
    } catch (e) {
      $showErrorDialog(context, e.toString());
    }
  }

  Future<void> _save() async {
    try {
      final _uploaded = await FirebaseStorageService.uploadFile(_mainImage!);
      _recipe.imagesList.add(_uploaded);
      for (var i = 0; i < _recipe.steps.length; i++) {
        var _step = _recipe.steps[i];
        if (_step.local?.isNotEmpty ?? false) {
          _step.image = await FirebaseStorageService.uploadFile(_step.local!);
        }
      }
      var finalRecipe = await translateRecipe(recipe: _recipe);
      await RecipeFirestoreService()
          .insertFirestore(finalRecipe);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _update() async {
    try {
      if (_mainImage != null) {
        final _uploaded = await FirebaseStorageService.uploadFile(_mainImage!);
        _recipe.imagesList.add(_uploaded);
      }
      for (var i = 0; i < _recipe.steps.length; i++) {
        var _step = _recipe.steps[i];
        if (_step.local?.isNotEmpty ?? false) {
          _step.image = await FirebaseStorageService.uploadFile(_step.local!);
        }
      }
      var finalRecipe = await translateRecipe(recipe: _recipe);

      await RecipeFirestoreService()
          .updateFirestore(finalRecipe);
    } catch (_) {
      rethrow;
    }
  }
}
