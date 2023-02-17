import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../themes/design_course_app_theme.dart';

class IconProgressIndicator extends StatefulWidget {
  final isLoading;
  const IconProgressIndicator({Key? key, required this.isLoading}) : super(key: key);

  @override
  State<IconProgressIndicator> createState() => _IconProgressIndicatorState();
}

class _IconProgressIndicatorState extends State<IconProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return  OverlayLoaderWithAppIcon(
      overlayOpacity: 0,
      appIcon: Image.asset('assets/images/iris_icon.png'),
      isLoading: widget.isLoading,
      child: const Text(''),
      circularProgressColor: DesignCourseAppTheme.IrisBlue,
    );
  }
}
