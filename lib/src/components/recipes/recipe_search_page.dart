import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/components/recipes/recipe_widget.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/app_firestore_service.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';

import '../../widgets/app_dropdown_widget.dart';

class RecipeSearchPage extends StatefulWidget {
  const RecipeSearchPage({Key? key}) : super(key: key);

  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

enum OrderBy {
  rating,
  duration,
}

class _RecipeSearchPageState extends State<RecipeSearchPage> with LocalizedStateMixin {
  List<RecipeModel> recipes = [];
  List<RecipeModel> filteredRecipes = [];
  List<String> _selectedCategories = [];
  OrderBy? _orderBy;
  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchData() async {
    recipes = await RecipeFirestoreService().fetchAllFirestoreFuture();
    filteredRecipes = recipes;
    setState(() {});
  }

  List<RecipeModel> filter() {
    filteredRecipes = recipes;
    List<RecipeModel> filtered = [];

    // Filtering by text
    if (_searchController.text.isNotEmpty) {
      for (var recipe in filteredRecipes) {
        if (recipe.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          filtered.add(recipe);
        }
      }
      if (filtered.isEmpty) return [];
      if (_selectedCategories.isNotEmpty) {
        List<RecipeModel> rawFiltered = [];
        for (var recipe in filtered) {
          bool haveCategory = false;
          for (var category in _selectedCategories) {
            for (var recipeCategory in recipe.category) {
              if (getCategoryKey(category: category) == recipeCategory) {
                haveCategory = true;
                break;
              }
            }
            if (haveCategory) break;
          }

          if (haveCategory) {
            rawFiltered.add(recipe);
          }
        }
        if (rawFiltered.isEmpty) {
          return [];
        } else {
          filtered = rawFiltered;
        }
      }
      //Sort Filtered and return
      if (_orderBy != null) {
        filtered = sort(filtered);
      }
      return filtered;
    } else if (_selectedCategories.isNotEmpty) {
      for (var recipe in filteredRecipes) {
        bool haveCategory = false;
        for (var category in _selectedCategories) {
          for (var recipeCategory in recipe.category) {
            if (getCategoryKey(category: category) == recipeCategory) {
              haveCategory = true;
              break;
            }
          }
          if (haveCategory) break;
        }

        if (haveCategory) {
          filtered.add(recipe);
        }
      }
      if (filtered.isEmpty) return [];

      //Sort Filtered and return
      if (_orderBy != null) {
        filtered = sort(filtered);
      }
      return filtered;
    } else {
      //Sort FilteredRecipe and return
      if (_orderBy != null) {
        filtered = sort(filteredRecipes);
      }
      return filtered;
    }
  }

  List<RecipeModel> sort(List<RecipeModel> myRecipes) {
    if (_orderBy != null) {
      if (_orderBy == OrderBy.rating) {
        myRecipes.sort((a, b) => a.rating.compareTo(b.rating));
        return myRecipes.reversed.toList();
      } else {
        myRecipes.sort((a, b) {
          var split1 = a.cookingTime.split(" ");
          var hour1 = split1[0].substring(0, split1[0].length - 1);
          var min1 = split1[1].substring(0, split1[1].length - 1);
          var time1 = hour1 + min1;

          var split2 = b.cookingTime.split(" ");
          var hour2 = split2[0].substring(0, split2[0].length - 1);
          var min2 = split2[1].substring(0, split2[1].length - 1);
          var time2 = hour2 + min2;

          return time1.compareTo(time2);
        });
        return myRecipes;
      }
    } else {
      return myRecipes;
    }
  }

  @override
  initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + 28,
          20,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            AppTextField(
              textEditingController: _searchController,
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 14, 0),
                child: Image.asset(
                  AppAssets.search,
                  width: 16,
                  height: 16,
                  color: AppTheme.neutralColor.shade200,
                ),
              ),
              hint: lang.search_recipe,
               onChanged: (value) {
                if (_searchController.text.isNotEmpty) {
                  filteredRecipes = filter();
                } else {
                  filteredRecipes = recipes;
                }
                setState(() {});
              },
            ),
            const SizedBox(height: 17),
            _buildTile(
              icon: AppAssets.profile,
              title: lang.category,
              text: _selectedCategories.isNotEmpty
                  ? _selectedCategories[0] +
                      (_selectedCategories.length > 1
                              ? " +" +
                                  (_selectedCategories.length - 1).toString()
                              : "")
                          .toString()
                  : "",
            ),
            const SizedBox(height: 9),
            _buildTile(
              icon: AppAssets.profile,
              title: lang.order_by,
              text: _orderBy != null
                  ? _orderBy == OrderBy.rating
                      ? "Rating"
                      : "Cooking Time"
                  : "",
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => RecipeWidget(
                  recipe: filteredRecipes[index],
                  padding: const EdgeInsets.only(bottom: 16),
                ),
                itemCount: filteredRecipes.length,
              ),
            ),
          ],
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
        await showDialog(
          context: context,
          builder: (context) {
            return SortingDialog(
              onChange: (List<String> categories) {
                _selectedCategories = categories;
              },
              onOrderByChange: (OrderBy? value) {
                _orderBy = value;
              },
              selectedOrderBy: _orderBy,
              selected: _selectedCategories,
            );
          },
        );
        if (_selectedCategories.isEmpty && _orderBy == null) {
          await fetchData();
        } else if (_selectedCategories.isNotEmpty || _orderBy != null) {
          filteredRecipes = filter();
        }
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
}

class SortingDialog extends StatefulWidget {
  const SortingDialog({
    Key? key,
    required this.onChange,
    required this.onOrderByChange,
    required this.selected,
    required this.selectedOrderBy,
  }) : super(key: key);

  final List<String> selected;
  final OrderBy? selectedOrderBy;
  final Function(List<String>) onChange;
  final Function(OrderBy?) onOrderByChange;

  @override
  _SortingDialogState createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> with LocalizedStateMixin {
  final Map<String, bool> _checkedCategories = {};
  OrderBy? _selectedOrderBy;

  var categories = getCategories();

  late GlobalKey<FormFieldState> _key;

  buildSelectedCategoryMap() {
    for (var cat in categories) {
      _checkedCategories[cat] = false;
    }
    if (widget.selected.isNotEmpty) {
      for (var cat in widget.selected) {
        _checkedCategories[cat] = true;
      }
    }
    _selectedOrderBy = widget.selectedOrderBy;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    buildSelectedCategoryMap();
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          height: 600,
          width: 500,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.filter_alt_off,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(width: 7),
                        Text(
                          "Clear Filter",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _clearFilter(),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                lang.order_by + ':',
                style: kBoldW600f16Style.copyWith(color: AppTheme.primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AppDropDownWidget<OrderBy>(
                  key: _key,
                  items: const [
                    DropdownMenuItem(
                      child: Text("Rating"),
                      value: OrderBy.rating,
                    ),
                    DropdownMenuItem(
                      child: Text("Cooking Time"),
                      value: OrderBy.duration,
                    ),
                  ],
                  onChanged: (OrderBy? value) {
                    _selectedOrderBy = value;
                    widget.onOrderByChange(value!);
                    setState(() {});
                  },
                  value: _selectedOrderBy,
                  hint: lang.select_type,
                  onSaved: (value) {},
                  label: '',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                lang.select_categories + ':',
                style: kBoldW600f16Style.copyWith(color: AppTheme.primaryColor),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(categories[index]),
                          value: _checkedCategories[categories[index]],
                          onChanged: (bool? value) {
                            _checkedCategories[categories[index]] =
                                value ?? false;
                            widget.onChange(_checkedCategories.keys
                                .where((element) =>
                                    _checkedCategories[element] == true)
                                .toList());
                            setState(() {});
                          },
                        );
                      },
                      itemCount: getCategories().length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      addAutomaticKeepAlives: true,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Apply Filter"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _clearFilter() {
    _key.currentState?.reset();
    _selectedOrderBy = null;
    if (widget.selected.isNotEmpty) {
      for (var cat in _checkedCategories.keys) {
        _checkedCategories[cat] = false;
      }
    }
    setState(() {});

    widget.onChange([]);
    widget.onOrderByChange(null);
    Navigator.of(context).pop();
  }
}
