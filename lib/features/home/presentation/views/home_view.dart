// lib/features/home/presentation/pages/home_view.dart
import 'package:flutter/material.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/home/presentation/views/widgets/desktop_home_view_body.dart';
import 'package:lms/features/home/presentation/views/widgets/mobile_home_view_body.dart';

class HomeView extends StatelessWidget {
  final String username;

  const HomeView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    print("USERNAME IN HOMEVIEW$username");

    return CustomScaffold(
        body: AdaptiveLayout(
      mobileLayout: (context) => MobileHomeViewBody(username: username),
      tabletLayout: (context) => const SizedBox(),
      desktopLayout: (context) => DesktopHomeViewBody(username: username),
    ));
  }
}
