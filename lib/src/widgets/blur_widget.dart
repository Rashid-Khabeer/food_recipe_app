import 'dart:ui';
import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  const BlurWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          width: 58,
          height: 28,
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff303030).withOpacity(0.3),
          ),
          child: child,
        ),
      ),
    );
  }
}
