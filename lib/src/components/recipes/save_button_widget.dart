import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/services/firebase_auth_service.dart';
import 'package:food_recipie_app/src/utils/localized_mixin.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({Key? key, required this.recipe, required this.onClick}) : super(key: key);
  final RecipeModel recipe;
  final Function onClick;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> with LocalizedStateMixin {
  final _userId = FirebaseAuthService.userId;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => widget.onClick(),
      child: Row(
        children: [
          Image.asset(
            AppAssets.saved,
            color: widget.recipe.savedUsersIds
                .contains(_userId)
                ? AppTheme.primaryColor.shade500
                : const Color(0xff130F26),
            height: 14.61,
            width: 18.22,
          ),
          const SizedBox(width: 9),
          Text(
            widget.recipe.savedUsersIds
                .contains(_userId)
                ? lang.unsave
                : lang.save,
          ),
        ],
      ),
      style: TextButton.styleFrom(
        minimumSize: const Size(32, 32),
        primary: AppTheme.primaryColor.shade500,
        backgroundColor: Colors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 5,
        // shape: const CircleBorder(),
      ),
    );
  }
}
