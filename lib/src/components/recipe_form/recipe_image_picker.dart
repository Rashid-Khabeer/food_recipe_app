import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/sheets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reusables/reusables.dart';

class RecipeImageController extends ChangeNotifier {
  RecipeImageController({
    this.url,
    required this.onChanged,
  });

  final String? url;
  final void Function(String) onChanged;
  XFile? _pickedFile;

  void selectImage(BuildContext context) async {
    $showImageSelectorSheet(
      context,
      (image) {
        _pickedFile = image;
        notifyListeners();
        onChanged(_pickedFile!.path);
      },
    );
  }
}

class RecipeImagePicker extends ControlledWidget<RecipeImageController> {
  const RecipeImagePicker({
    Key? key,
    required this.imageController,
  }) : super(key: key, controller: imageController);

  final RecipeImageController imageController;

  @override
  _RecipeImagePickerState createState() => _RecipeImagePickerState();
}

class _RecipeImagePickerState extends State<RecipeImagePicker>
    with ControlledStateMixin, LocalizedStateMixin {
  @override
  Widget build(BuildContext context) {
    var _isImageSelected = widget.controller._pickedFile != null;
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(0, 24, 0, 20),
      decoration: BoxDecoration(
        color: AppTheme.neutralColor.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        if (widget.controller._pickedFile != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(widget.controller._pickedFile!.path),
              fit: BoxFit.cover,
            ),
          )
        else ...[
          if (widget.controller.url?.isNotEmpty ?? false)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.controller.url!,
                fit: BoxFit.cover,
              ),
            )
          else
            Positioned(
              top: 10,
              left: 16,
              child: Text(
                lang.main_photo + ' (required)',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
        ],
        Positioned(
          top: 10,
          right: 8,
          child: TextButton(
            child: const Icon(CupertinoIcons.pencil),
            onPressed: () => widget.controller.selectImage(context),
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
    );
  }
}
