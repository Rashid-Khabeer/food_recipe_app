import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/widgets/blur_widget.dart';

class ShowRatingWidget extends StatelessWidget {
  const ShowRatingWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

  final double rating;

  @override
  Widget build(BuildContext context) {
    return BlurWidget(
      child: Row(children: [
        Image.asset(
          AppAssets.star,
          color: Colors.white,
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]),
    );
  }
}
