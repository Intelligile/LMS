import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout(
      {super.key,
      required this.mobileLayout,
      required this.tabletLayout,
      required this.notebookLayout,
      required this.desktopLayout});
  final WidgetBuilder mobileLayout, tabletLayout, notebookLayout, desktopLayout;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileLayout(context);
        } else if (constraints.maxWidth < 980) {
          return tabletLayout(context);
        } else if (constraints.maxWidth < 1200) {
          return notebookLayout(context);
        } else {
          return desktopLayout(context);
        }
      },
    );
  }
}
