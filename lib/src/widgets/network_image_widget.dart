import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';
import 'package:food_recipie_app/src/widgets/loading_animation.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.noImageWidget,
  }) : super(key: key);
  final String? url;
  final Widget? noImageWidget;

  @override
  Widget build(BuildContext context) {
    Widget _noDataWidget = noImageWidget ?? const Text('No Image');
    if (url?.isEmpty ?? true) {
      return _noDataWidget;
    }
    return Image.network(
      url!,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return LoadingWidget(size: 20, color: AppTheme.primaryColor.shade500);
      },
      errorBuilder: (context, exception, stackTrace) {
        return _noDataWidget;
      },
    );
  }
}
