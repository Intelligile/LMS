import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_drawer.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroudColor;
  final Widget? floatingActionButton;

  const CustomScaffold(
      {super.key,
      required this.body,
      this.backgroudColor,
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: CustomAppBar(
          username: userName, // Pass the username here
        ),
      ),
      backgroundColor: backgroudColor ?? Colors.white,
      body: Row(
        children: [
          const Expanded(
            child: CustomExpandedDrawer(),
          ),
          Expanded(flex: 4, child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
