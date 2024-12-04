// lib/features/home/presentation/pages/home_view.dart
import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  final String username;

  const HomeView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    print("USERNAME IN HOMEVIEW$username");
    return Scaffold(
      body: SafeArea(
        child: HomeViewBody(username: username),
      ),
    );
  }
}
