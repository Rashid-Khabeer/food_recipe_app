import 'package:flutter/cupertino.dart';
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
  var date = DateTime.utc(2022, 1, 1, 0, 0, 0, 0, 0);

  final Map<String, bool> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    buildSelectedCategoryMap();
  }

  buildSelectedCategoryMap() {
    for (var cat in kRecipeCategories) {
      _selectedCategories[cat] = false;
    }
    setState(() {});
  }

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
            onTap: () async {
              await _showDialog(
                CupertinoDatePicker(
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime value) {
                    widget.recipe.cookingTime = value.hour.toString() +
                        'H ' +
                        value.minute.toString() +
                        'M';
                    widget.onChanged(widget.recipe);
                  },
                ),
              );
              setState(() {});
            },
            readonly: true,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Select Categories',
              style: kBoldW600f16Style.copyWith(color: Colors.black),
            ),
          ),
          ///TODO Fix Category Scrolling
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(kRecipeCategories[index]),
                value: _selectedCategories[kRecipeCategories[index]],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedCategories[kRecipeCategories[index]] =
                        value ?? false;
                  });
                  widget.recipe.category = _selectedCategories.keys.toList();
                  widget.onChanged(widget.recipe);
                },
              );
            },
            itemCount: _selectedCategories.length,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 20),
          //   child: AppDropDownWidget<String>(
          //     hint: 'Category',
          //     label: 'Category',
          //     items: kRecipeCategories
          //         .map(
          //           (e) => DropdownMenuItem(
          //             child: Text(e),
          //             value: e,
          //           ),
          //         )
          //         .toList(),
          //     onChanged: (value) {
          //       if (value?.isEmpty ?? true) {
          //         return;
          //       }
          //       if (widget.recipe.category.contains(value)) {
          //         $showSnackBar(context, 'Already selected');
          //         return;
          //       }
          //       widget.recipe.category.add(value!);
          //       widget.onChanged(widget.recipe);
          //       setState(() {});
          //     },
          //   ),
          // ),
          //
          // for (var cat in widget.recipe.category)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 3),
          //     child: Row(children: [
          //       Container(
          //         width: 7,
          //         height: 7,
          //         margin: const EdgeInsets.only(right: 7),
          //         decoration: const BoxDecoration(
          //           color: Colors.black,
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //       Text(cat),
          //     ]),
          //   ),
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

  Future<void> _showDialog(Widget child) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}