import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/base/nav.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipe_form/ingredients_form.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_form_view.dart';
import 'package:food_recipie_app/src/components/recipe_form/recipe_image_picker.dart';
import 'package:food_recipie_app/src/components/recipe_form/steps_form.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/services/firebase_storage_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';
import 'package:reusables/reusables.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({
    Key? key,
    this.recipeModel,
  }) : super(key: key);

  final RecipeModel? recipeModel;

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;
  var _isEdit = false;

  String? _mainImage;
  late RecipeModel _recipe;
  late RecipeImageController _imageController;
  late IngredientsController _ingredientsController;
  late StepsController _stepsController;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.recipeModel != null;
    _recipe = widget.recipeModel ??
        RecipeModel(
          name: '',
          imagesList: [],
          rating: 0,
          userId: FirebaseAuthService.userId,
          category: [],
          cookingTime: '5 m',
          ingredients: [IngredientsModel(name: '', quantity: '')],
          ratings: [],
          savedUsersIds: [],
          serves: '1',
          steps: [StepsModel(step: '', image: '')],
          timestamp: Timestamp.now(),
        );
    _imageController = RecipeImageController(
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
        title: 'Edit recipe',
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
            const Text('Edit Recipe', style: kBoldW600f24Style),
            RecipeImagePicker(imageController: _imageController),
            AppTextField(
              hint: 'Recipe Name',
              label: 'Recipe Name',
              validator: InputValidator.required(
                message: 'Name is required',
              ),
              onSaved: (value) => _recipe.name = value ?? '',
            ),
            const SizedBox(height: 16),
            _buildTile(
              icon: AppAssets.friends,
              title: 'Serves',
              text: _recipe.serves,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 11),
              child: _buildTile(
                icon: AppAssets.time,
                title: 'Cooking time',
                text: _recipe.cookingTime,
              ),
            ),
            _buildTile(
              icon: AppAssets.friends,
              title: 'Category',
              text: _recipe.category.isNotEmpty ? _recipe.category.first : '',
            ),
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
              onPressed: _submit,
              child: const Text('Save Recipe'),
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
            onChanged: (value) => _recipe = value,
            recipe: _recipe,
          ),
        );
        setState(() {});
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
    if (_mainImage?.isEmpty ?? true) {
      $showSnackBar(context, 'Main photo is required');
      return;
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
        future: _save(),
        context: context,
        arguments: 'Saving...',
      );
      $showSnackBar(context, 'Recipe Added!');
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
      await RecipeFirestoreService().insertFirestore(_recipe);
    } catch (_) {
      rethrow;
    }
  }
}
