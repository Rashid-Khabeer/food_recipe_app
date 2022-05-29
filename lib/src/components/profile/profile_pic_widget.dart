import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/sheets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reusables/reusables.dart';

class ProfilePicController extends ChangeNotifier {
  ProfilePicController({this.url});

  final String? url;
  XFile? _pickedFile;

  XFile? get pickedFile => _pickedFile;

  void imagePicked(XFile file) {
    _pickedFile = file;
    notifyListeners();
  }
}

class ProfilePicWidget extends ControlledWidget<ProfilePicController> {
  const ProfilePicWidget({
    Key? key,
    required this.picController,
  }) : super(key: key, controller: picController);

  final ProfilePicController picController;

  @override
  _ProfilePicWidgetState createState() => _ProfilePicWidgetState();
}

class _ProfilePicWidgetState extends State<ProfilePicWidget>
    with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    late Widget _child;
    if (widget.controller.pickedFile != null) {
      _child = ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(
          File(widget.controller.pickedFile!.path),
          fit: BoxFit.cover,
        ),
      );
    } else {
      if (widget.controller.url?.isNotEmpty ?? false) {
        _child = ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            widget.controller.url!,
            fit: BoxFit.cover,
          ),
        );
      } else {
        _child = Icon(
          CupertinoIcons.person,
          size: 60,
          color: AppTheme.primaryColor.shade500,
        );
      }
    }
    return Stack(children: [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.primaryColor.shade500, width: 0.2),
        ),
        child: _child,
      ),
      Positioned(
        right: -6,
        bottom: 9,
        child: InkWell(
          onTap: () {
            $showImageSelectorSheet(context, widget.controller.imagePicked);
          },
          child: Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.shade500,
                width: 0.2,
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              AppAssets.pencil,
              color: AppTheme.primaryColor.shade500,
            ),
          ),
        ),
      ),
    ], clipBehavior: Clip.none);
  }
}
