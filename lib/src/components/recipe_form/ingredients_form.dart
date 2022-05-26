import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
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
    ingredients.add(IngredientsModel(name: '', quantity: ''));
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
    with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._buildData(),
      const SizedBox(height: 1),
      GestureDetector(
        onTap: widget.controller._add,
        child: Row(children: const [
          Icon(Icons.add),
          Text('Add new Ingredient', style: kBoldW600f24Style),
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
        child: Row(children: [
          Expanded(
            flex: 3,
            child: AppTextField(
              hint: 'Item name',
              onChanged: (value) {
                widget.controller.ingredients[i].name = value ?? '';
                widget.controller.onChanged(widget.controller.ingredients);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AppTextField(
                hint: 'Quantity',
                onChanged: (value) {
                  widget.controller.ingredients[i].quantity = value ?? '';
                  widget.controller.onChanged(widget.controller.ingredients);
                },
              ),
            ),
          ),
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
      ));
    }
    return _list;
  }
}
