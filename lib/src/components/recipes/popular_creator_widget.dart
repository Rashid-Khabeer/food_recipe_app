import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/data/models.dart';

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
                backgroundImage: NetworkImage(widget.user.profilePicture ?? ''),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              (widget.user.name ?? '').split(' ')[0],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12,),
            ),
          ],
        ),
      ),
    );
  }
}
