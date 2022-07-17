import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/data.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
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

class _RecipeFormViewState extends State<RecipeFormView> with LocalizedStateMixin {
  final _scrollController = ScrollController();
  var date = DateTime.utc(2022, 1, 1, 0, 0, 0, 0, 0);

  var categories = getCategories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: _scrollController,
        title: lang.return_text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Text(lang.recipe_form, style: kBoldW600f24Style),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
              sliver: SliverToBoxAdapter(
                child: AppTextField(
                  hint: lang.serves,
                  label: lang.serves,
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
            ),
            SliverToBoxAdapter(
              child: AppTextField(
                hint: lang.cooking_time,
                label: lang.cooking_time,
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
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 10.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  lang.select_categories,
                  style: kBoldW600f16Style.copyWith(color: Colors.black),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  final _cat = categories[index];
                  final key = getCategoryKey(category: _cat);
                  final _isSelected = widget.recipe.category.contains(key);
                  return CheckboxListTile(
                    title: Text(_cat),
                    value: _isSelected,
                    activeColor: AppTheme.primaryColor.shade500,
                    onChanged: (bool? value) {
                      if (_isSelected) {
                        widget.recipe.category.remove(key);
                      } else {
                        widget.recipe.category.add(key!);
                      }
                      setState(() {});
                      widget.onChanged(widget.recipe);
                    },
                  );
                },
                childCount: categories.length,
              ),
            ),
          ],
        ),
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
