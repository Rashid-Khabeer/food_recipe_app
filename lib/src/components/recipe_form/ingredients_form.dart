import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/app_dropdown_widget.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:reusables/reusables.dart';

class IngredientsController extends ChangeNotifier {
  IngredientsController({
    required this.onChanged,
    required this.ingredients,
  });

  final List<IngredientsModel> ingredients;
  final void Function(List<IngredientsModel>) onChanged;

  void _add() {
    ingredients.add(IngredientsModel(name: '', quantity: '', unit: null));
    notifyListeners();
    onChanged(ingredients);
  }

  void _remove(int index) {
    ingredients.removeAt(index);
    notifyListeners();
    onChanged(ingredients);
  }
}

class IngredientsFormWidget extends ControlledWidget<IngredientsController> {
  const IngredientsFormWidget({
    Key? key,
    required this.ingredientsController,
  }) : super(key: key, controller: ingredientsController);

  final IngredientsController ingredientsController;

  @override
  _IngredientsFormWidgetState createState() => _IngredientsFormWidgetState();
}

class _IngredientsFormWidgetState extends State<IngredientsFormWidget>
    with ControlledStateMixin, LocalizedStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._buildData(),
      const SizedBox(height: 1),
      GestureDetector(
        onTap: widget.controller._add,
        child: Row(children: [
          const Icon(Icons.add),
          Text(lang.add_new_ingredient, style: kBoldW600f24Style),
        ]),
      ),
      const SizedBox(height: 13),
    ]);
  }

  List<Widget> _buildData() {
    var _list = <Widget>[];
    for (var i = 0; i < widget.controller.ingredients.length; i++) {
      _list.add(Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: AppTextField(
                  hint: lang.item_name,
                  validator: InputValidator.required(
                    message: 'Name is required',
                  ),
                  value: widget.controller.ingredients[i].name,
                  onChanged: (value) {
                    widget.controller.ingredients[i].name = value ?? '';
                    widget.controller.onChanged(widget.controller.ingredients);
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => widget.controller._remove(i),
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Icon(Icons.remove, size: 15),
                ),
              ),
            ]),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: 'Qty',
                    value: widget.controller.ingredients[i].quantity,
                    onChanged: (value) {
                      widget.controller.ingredients[i].quantity = value ?? '';
                      widget.controller
                          .onChanged(widget.controller.ingredients);
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: AppDropDownWidget(
                    hint: "Unit",
                    value: widget.controller.ingredients[i].unit,
                    onChanged: (String? v) {
                      widget.controller.ingredients[i].unit = v ?? '';
                      widget.controller
                          .onChanged(widget.controller.ingredients);
                    },
                    items: const [
                      DropdownMenuItem(child: Text('kg'), value: 'kg'),
                      DropdownMenuItem(child: Text('g'), value: 'g',),
                      DropdownMenuItem(child: Text('L'), value: 'L'),
                      DropdownMenuItem(child: Text('ml'), value: 'ml'),
                      DropdownMenuItem(child: Text('u'), value: 'u'),
                    ],
                    label: '',
                    height: 45,
                  ),
                ),
                const SizedBox(height: 24, width: 26),
              ],
            ),
          ],
        ),
      ));
    }
    return _list;
  }
}
