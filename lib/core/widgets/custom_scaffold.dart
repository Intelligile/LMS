import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_drawer.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
import 'package:lms/features/home/presentation/views/widgets/expanded_and_collapsed_drawers.dart';
import 'package:provider/provider.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroudColor;
  final Widget? floatingActionButton;

  CustomScaffold({
    super.key,
    required this.body,
    this.backgroudColor,
    this.floatingActionButton,
  });

  // GlobalKey to control the Scaffold's state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
      builder: (context, drawerStateProvider, child) {
        bool drawerOpen = drawerStateProvider.isDrawerOpen;
        double width = MediaQuery.sizeOf(context).width;

        // Calculate drawer width based on screen size and state
        double drawerWidth = drawerOpen
            ? math.max(width * 0.25, 75.0)
            : math.max(width * 0.01, 75.0);

        return Scaffold(
          key: _scaffoldKey, // Assign the GlobalKey to Scaffold
          appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 60),
              child: width > 600
                  ? CustomAppBar(username: usernamePublic)
                  : CustomMobileAppBar(
                      username: usernamePublic,
                      button: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ))),
          body: Row(
            children: [
              if (width > 600)
                SizedBox(
                  width: drawerWidth,
                  child: const CustomDrawer(),
                ),
              Expanded(
                child: body,
              ),
            ],
          ),
          floatingActionButton: floatingActionButton,
          drawer: width < 600
              ? Drawer(
                  child: CustomExpandedDrawer(
                    onPressed: () {
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                )
              : null,
        );
      },
    );
  }
}
