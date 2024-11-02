import 'package:flutter/material.dart';
import 'package:lms/constants.dart';
import 'package:lms/features/home/presentation/views/widgets/app_bar_grid_and_title.dart';
import 'package:lms/features/home/presentation/views/widgets/app_bar_icons.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_responsive_search_text_field.dart';

class CustomAppBar extends StatefulWidget {
  final String username;

  const CustomAppBar({
    super.key,
    required this.username, // Add this parameter
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const AppBarGridIconAndTitle(),
          const Expanded(child: SizedBox()),
          const Expanded(flex: 3, child: ResponsiveTextField()),
          const Expanded(flex: 2, child: SizedBox()),
          UserOptionsIcons(
            username: widget.username, // Pass the username here
          ),
        ],
      ),
    );
  }
}
