import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/data.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';
import 'package:image_picker/image_picker.dart';

import '../app.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({Key? key, required this.mediaQueryData, required this.onImageChanged}) : super(key: key);

  final MediaQueryData mediaQueryData;
  final Function(XFile) onImageChanged;

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> with LocalizedStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        10,
        0,
        10,
        widget.mediaQueryData.padding.bottom + 20,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(children: [
            Text(
              lang.select_image_from,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildSelectionRowWidget(
              context: context,
              icon: CupertinoIcons.photo_camera,
              title: lang.camera,
              imagePicked: widget.onImageChanged,
              source: ImageSource.camera,
            ),
            const SizedBox(height: 5),
            _buildSelectionRowWidget(
              context: context,
              icon: CupertinoIcons.photo,
              title: lang.gallery,
              imagePicked: widget.onImageChanged,
              source: ImageSource.gallery,
            ),
          ], mainAxisSize: MainAxisSize.min),
        ),
      ),
    );
  }
}

$showImageSelectorSheet(
  BuildContext context,
  void Function(XFile) onImageChanged,
) {
  final _mediaQuery = MediaQuery.of(context);
  showCupertinoModalPopup(
    context: context,
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    builder: (ctx) {
      return ImageSelector(mediaQueryData: _mediaQuery, onImageChanged: onImageChanged);
    },
  );
}

Future<void> $showLoginBottomSheet(
  BuildContext context,
  String title,
  bool isTablet,
  void Function(loginType) onLoginSelected,
) async {
  final _mediaQuery = MediaQuery.of(context);
  await showCupertinoModalPopup(
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
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              _buildLoginSelectionRowWidget(
                context: context,
                asset: AppAssets.google,
                title: 'Google',
                source: loginType.google,
                loginTypeSelected: onLoginSelected,
                isTablet: isTablet,
              ),
              const SizedBox(height: 5),
              _buildLoginSelectionRowWidget(
                context: context,
                asset: AppAssets.facebook,
                title: 'Facebook',
                source: loginType.facebook,
                loginTypeSelected: onLoginSelected,
                isTablet: isTablet,
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
        Navigator.of(context).pop();
        imagePicked(_result);
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

Widget _buildLoginSelectionRowWidget({
  required BuildContext context,
  required String asset,
  required String title,
  required loginType source,
  required void Function(loginType) loginTypeSelected,
  bool isTablet = false,
}) {
  return InkWell(
    splashColor: AppTheme.primaryColor.shade400,
    highlightColor: Colors.transparent,
    borderRadius: BorderRadius.circular(5),
    onTap: () async {
      loginTypeSelected(source);
      Navigator.of(context).pop();
    },
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(children: [
        Image.asset(asset, height: isTablet ? 30 : 20, width: isTablet ? 30 : 20),
        const SizedBox(width: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ]),
    ),
  );
}

class DefaultLangDialog extends StatefulWidget {
  const DefaultLangDialog({Key? key}) : super(key: key);

  @override
  _DefaultLangDialogState createState() => _DefaultLangDialogState();
}

class _DefaultLangDialogState extends State<DefaultLangDialog>
    with LocalizedStateMixin {
  late String _default;

  @override
  void initState() {
    super.initState();
    _default = AppData().getDefaultLang();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(children: [
            const Text(
              'Default Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            GestureDetector(
              onTap: Navigator.of(context).pop,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          _buildTile('en', 'English'),
          _buildTile('es', 'Spanish'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              appController.changeLocale(_default);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(
              primary: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String lang, String text) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          _default = lang;
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            _default == lang
                ? Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: AppTheme.primaryColor,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(width: 14),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    _default == lang ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
