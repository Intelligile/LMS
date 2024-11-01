// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lms/core/utils/theme_provider.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
import 'package:lms/features/home/presentation/views/widgets/expanded_and_collapsed_drawers.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
      builder: (context, drawerStateProvider, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        bool drawerOpen = drawerStateProvider.isDrawerOpen;
        return Container(
          color: themeProvider.themeMode == ThemeMode.light
              ? const Color(0xffe9e9e9)
              : const Color.fromARGB(255, 90, 86, 86),
          child: drawerOpen
              ? CustomExpandedDrawer(
                  onPressed: () {
                    drawerStateProvider.toggleDrawer();
                  },
                )
              : CustomCollapsedDrawer(
                  onPressed: () {
                    drawerStateProvider.toggleDrawer();
                  },
                ),
        );
      },
    );
  }
}
