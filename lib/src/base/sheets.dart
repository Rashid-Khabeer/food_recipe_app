import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:image_picker/image_picker.dart';

$showImageSelectorSheet(
  BuildContext context,
  void Function(XFile) onImageChanged,
) {
  final _mediaQuery = MediaQuery.of(context);
  showCupertinoModalPopup(
    context: context,
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          10,
          0,
          10,
          _mediaQuery.padding.bottom + 20,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(children: [
              const Text(
                'Select Image From',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              _buildSelectionRowWidget(
                context: context,
                icon: CupertinoIcons.photo_camera,
                title: 'Camera',
                imagePicked: onImageChanged,
                source: ImageSource.camera,
              ),
              const SizedBox(height: 5),
              _buildSelectionRowWidget(
                context: context,
                icon: CupertinoIcons.photo,
                title: 'Gallery',
                imagePicked: onImageChanged,
                source: ImageSource.gallery,
              ),
            ], mainAxisSize: MainAxisSize.min),
          ),
        ),
      );
    },
  );
}

Widget _buildSelectionRowWidget({
  required BuildContext context,
  required IconData icon,
  required String title,
  required ImageSource source,
  required void Function(XFile) imagePicked,
}) {
  return InkWell(
    splashColor: AppTheme.primaryColor.shade400,
    highlightColor: Colors.transparent,
    borderRadius: BorderRadius.circular(5),
    onTap: () async {
      final _result = await ImagePicker().pickImage(source: source);
      if (_result != null) {
        imagePicked(_result);
        Navigator.of(context).pop();
      }
    },
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(children: [
        Icon(icon, size: 20),
        const SizedBox(width: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
    ),
  );
}
