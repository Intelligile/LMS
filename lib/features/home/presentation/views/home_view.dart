// lib/features/home/presentation/pages/home_view.dart
import 'package:flutter/material.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:lms/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  final String username;

  const HomeView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    print("USERNAME IN HOMEVIEW$username");
    return CustomScaffold(
        body: AdaptiveLayout(
      mobileLayout: (context) => const SizedBox(),
      tabletLayout: (context) => const SizedBox(),
      desktopLayout: (context) => HomeViewBody(username: username),
    ));
  }
}
