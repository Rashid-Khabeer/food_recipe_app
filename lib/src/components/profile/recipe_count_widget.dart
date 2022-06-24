import 'package:flutter/cupertino.dart';
import 'package:reusables/reusables.dart';

class RecipeCountController extends ChangeNotifier {
  var _count = 0;

  void change(int count) {
    _count = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}

class RecipeCountWidget extends ControlledWidget<RecipeCountController> {
  const RecipeCountWidget({
    Key? key,
    required this.countController,
  }) : super(key: key, controller: countController);

  final RecipeCountController countController;

  @override
  _RecipeCountWidgetState createState() => _RecipeCountWidgetState();
}

class _RecipeCountWidgetState extends State<RecipeCountWidget>
    with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.controller._count.toString(),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
