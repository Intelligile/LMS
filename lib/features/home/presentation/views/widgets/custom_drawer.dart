// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
import 'package:lms/features/home/presentation/views/widgets/expanded_and_collapsed_drawers.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
      builder: (context, drawerStateProvider, child) {
        bool drawerOpen = drawerStateProvider.isDrawerOpen;
        return Container(
          color: const Color(0xffe9e9e9),
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
