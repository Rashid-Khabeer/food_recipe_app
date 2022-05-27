import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/modals.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/app_dropdown_widget.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:food_recipie_app/src/widgets/custom_app_bar.dart';

class RecipeFormView extends StatefulWidget {
  const RecipeFormView({
    Key? key,
    required this.onChanged,
    required this.recipe,
  }) : super(key: key);

  final RecipeModel recipe;
  final void Function(RecipeModel) onChanged;

  @override
  _RecipeFormViewState createState() => _RecipeFormViewState();
}

class _RecipeFormViewState extends State<RecipeFormView> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: 'Recipe Form',
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text('Recipe Form', style: kBoldW600f24Style),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
            child: AppTextField(
              hint: 'Serves',
              label: 'Serves',
              textEditingController: TextEditingController(
                text: widget.recipe.serves,
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.recipe.serves = value ?? '';
                widget.onChanged(widget.recipe);
              },
            ),
          ),
          AppTextField(
            hint: 'Cooking time',
            label: 'Cooking time',
            textEditingController: TextEditingController(
              text: widget.recipe.cookingTime,
            ),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              widget.recipe.cookingTime = value ?? '';
              widget.onChanged(widget.recipe);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AppDropDownWidget<String>(
              hint: 'Category',
              label: 'Category',
              items: kRecipeCategories
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value?.isEmpty ?? true) {
                  return;
                }
                if (widget.recipe.category.contains(value)) {
                  $showSnackBar(context, 'Already selected');
                  return;
                }
                widget.recipe.category.add(value!);
                widget.onChanged(widget.recipe);
                setState(() {});
              },
            ),
          ),
          Text(
            'Selected Categories',
            style: kBoldW600f16Style.copyWith(color: Colors.black),
          ),
          for (var cat in widget.recipe.category)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 7),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(cat),
              ]),
            ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
