import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_drawer.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
import 'package:provider/provider.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroudColor;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    required this.body,
    this.backgroudColor,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
      builder: (context, drawerStateProvider, child) {
        bool drawerOpen = drawerStateProvider.isDrawerOpen;
        double width = MediaQuery.sizeOf(context).width;

        //calculate drawer width based on screen size and state
        double drawerWidth = drawerOpen
            ? math.max(width * 0.25, 75.0)
            : math.max(width * 0.01, 75.0);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: width > 600
                ? CustomAppBar(
                    username: usernamePublic,
                  )
                : CustomMobileAppBar(username: usernamePublic),
          ),
          body: Row(
            children: [
              MediaQuery.sizeOf(context).width > 600
                  ? SizedBox(
                      width: drawerWidth,
                      child: const CustomDrawer(),
                    )
                  : const SizedBox(),
              Expanded(
                child: body,
              ),
            ],
          ),
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }
}
