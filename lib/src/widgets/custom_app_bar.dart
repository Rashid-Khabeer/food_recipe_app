import 'dart:math';
import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/assets.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:reusables/reusables.dart';

class CustomAppBar extends ControlledWidget<ScrollController>
    with PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.canPop = true,
    this.color,
    ScrollController? controller,
  }) : super(key: key, controller: controller ?? ScrollController());

  final String? title;
  final List<Widget>? actions;
  final bool canPop;
  final Color? color;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    return const Size.fromHeight(56);
  }
}

class _CustomAppBarState extends State<CustomAppBar> with ControlledStateMixin {
  var opacity = 0.0;

  void _calculateOpacity() =>
      opacity = min(1, max(0, (widget.controller.offset / 56)));

  @override
  void rebuild() {
    if (widget.controller.hasClients) {
      if (widget.controller.offset > 0 && opacity != 1) {
        _calculateOpacity();
        super.rebuild();
      } else if (opacity != 0) {
        _calculateOpacity();
        super.rebuild();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateOpacity();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    late double elevation;

    if (widget.controller.hasClients) {
      elevation = widget.controller.offset > 0 ? 7 : 0;
    } else {
      elevation = 0;
    }

    return SizedBox(
      height: 56 + topPadding,
      child: Material(
        color: widget.color ??
            (widget.controller.offset > 0
                ? Colors.white
                : AppTheme.backgroundColor),
        elevation: elevation,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding, left: 6),
          child: Row(children: [
            if (widget.canPop)
              IconButton(
                splashRadius: 28,
                onPressed: Navigator.of(context).pop,
                icon: Image.asset(AppAssets.back, width: 24, height: 24),
              ),
            if (widget.title != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Opacity(
                    opacity: widget.title == 'Volver' || widget.title == 'Return' ? 1: opacity,
                    child: Text(
                      widget.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.actions != null) ...[
              ...widget.actions!,
            ]
          ]),
        ),
      ),
    );
  }
}
