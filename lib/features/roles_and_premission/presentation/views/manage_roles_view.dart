import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/manage_roles_app_bar.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/manage_roles_view_body.dart';

class ManageRolesView extends StatelessWidget {
  ManageRolesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          leading: const SizedBox(),
          backgroundColor: const Color(0xfff0f4f7),
          flexibleSpace: ManageRolesAppBarBody(),
        ),
      ),
      body: ManageRolesViewBody(),
    );
  }
}
