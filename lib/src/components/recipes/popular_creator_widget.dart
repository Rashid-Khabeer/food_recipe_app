import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/data/models.dart';
import 'package:food_recipie_app/src/utils/const.dart';
import 'package:food_recipie_app/src/widgets/network_image_widget.dart';

class PopularCreatorWidget extends StatefulWidget {
  const PopularCreatorWidget({
    Key? key,
    required this.user,
    this.width,
  }) : super(key: key);

  final UserModel user;
  final double? width;

  @override
  State<PopularCreatorWidget> createState() => _PopularCreatorWidgetState();
}

class _PopularCreatorWidgetState extends State<PopularCreatorWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      ///TODO Implement Navigation
      onTap: () {},
      child: SizedBox(
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 75,
              height: 75,
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(widget.user.profilePicture ?? ''),
                child: widget.user.profilePicture!.isEmpty
                    ? Text(
                        widget.user.name?[0] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              (widget.user.name ?? '').split(' ')[0],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularCreatorBoxWidget extends StatefulWidget {
  const PopularCreatorBoxWidget({Key? key, required this.user})
      : super(key: key);

  final UserModel user;

  @override
  _PopularCreatorBoxWidgetState createState() =>
      _PopularCreatorBoxWidgetState();
}

class _PopularCreatorBoxWidgetState extends State<PopularCreatorBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///TODO Navigation
        // AppNavigation.to(context, RecipeDetailPage(recipe: widget.recipe));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.black12)]
                // image: DecorationImage(image: NetworkImage(widget.user.profilePicture ?? ''), fit: BoxFit.cover, )
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetworkImageWidget(url: widget.user.profilePicture ?? ''),
            ),
          ),
          Text(widget.user.name ?? '', style: kBoldW600f24Style),
        ],
      ),
    );
  }
}
