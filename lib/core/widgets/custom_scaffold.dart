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
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: CustomAppBar(
              username: usernamePublic,
            ),
          ),
          backgroundColor: backgroudColor ?? Colors.white,
          body: Row(
            children: [
              Expanded(
                flex: drawerOpen ? 2 : 1,
                child: const CustomDrawer(),
              ),
              Expanded(
                flex: drawerOpen ? 8 : 16,
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
