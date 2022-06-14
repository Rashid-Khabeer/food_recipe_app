import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/sheets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:food_recipie_app/src/widgets/app_text_field.dart';
import 'package:reusables/reusables.dart';

class StepsController extends ChangeNotifier {
  StepsController({
    required this.onChanged,
    required this.steps,
  });

  final List<StepsModel> steps;
  final void Function(List<StepsModel>) onChanged;

  void _add() {
    steps.add(StepsModel(step: '', image: ''));
    notifyListeners();
    onChanged(steps);
  }

  void _remove(int index) {
    steps.removeAt(index);
    notifyListeners();
    onChanged(steps);
  }

  void _selectImage(BuildContext context, int i) {
    $showImageSelectorSheet(
      context,
      (image) {
        steps[i].local = image.path;
        notifyListeners();
      },
    );
  }
}

class StepsFormWidget extends ControlledWidget<StepsController> {
  const StepsFormWidget({
    Key? key,
    required this.stepsController,
  }) : super(key: key, controller: stepsController);

  final StepsController stepsController;

  @override
  _StepsFormWidgetState createState() => _StepsFormWidgetState();
}

class _StepsFormWidgetState extends State<StepsFormWidget>
    with ControlledStateMixin, LocalizedStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._buildData(),
      GestureDetector(
        onTap: widget.controller._add,
        child: Row(children: [
          const Icon(Icons.add),
          Text(lang.add_another_step, style: kBoldW600f24Style),
        ]),
      ),
    ]);
  }

  List<Widget> _buildData() {
    var _list = <Widget>[];
    for (var i = 0; i < widget.controller.steps.length; i++) {
      var _isImageSelected =
          (widget.controller.steps[i].image?.isNotEmpty ?? false) ||
              (widget.controller.steps[i].local?.isNotEmpty ?? false);
      _list.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i == widget.controller.steps.length - 1 ? 10 : 17,
          ),
          child: Row(children: [
            Expanded(
              child: Column(children: [
                AppTextField(
                  hint: lang.steps_to_follow,
                  validator: InputValidator.required(
                    message: 'Step is required',
                  ),
                  value: widget.controller.steps[i].step,
                  onChanged: (value) {
                    widget.controller.steps[i].step = value ?? '';
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: _isImageSelected ? 182 : 90,
                  decoration: BoxDecoration(
                    color: AppTheme.neutralColor.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(children: [
                    if (widget.controller.steps[i].local != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(widget.controller.steps[i].local!),
                          fit: BoxFit.cover,
                        ),
                      )
                    else ...[
                      if (widget.controller.steps[i].image?.isNotEmpty ?? false)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.controller.steps[i].image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Positioned(
                          top: 10,
                          left: 16,
                          child: Text(
                            lang.uploaded_photo + ' (Optional)',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                    Positioned(
                      top: 10,
                      right: 8,
                      child: TextButton(
                        child: const Icon(CupertinoIcons.pencil),
                        onPressed: () =>
                            widget.controller._selectImage(context, i),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.white,
                          elevation: _isImageSelected ? 5 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(72),
                          ),
                          primary: AppTheme.primaryColor.shade500,
                        ),
                      ),
                    ),
                  ], fit: StackFit.expand),
                ),
              ]),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
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
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      );
    }
    return _list;
  }
}
