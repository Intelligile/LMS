import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/app_bar_body.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/roles_and_premission_dashboard_view_body.dart';

List<Authority> authorities = [];
List<Permission> singleRolesPermissions = [];
List<Permission> allPermissions = [];
List<UserDto> users = [];

class RolesAndPermissionDashboardView extends StatelessWidget {
  const RolesAndPermissionDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          leading: const SizedBox(),
          backgroundColor: const Color(0xfff0f4f7),
          flexibleSpace: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppBarBody(),
          ),
        ),
      ),
      body: const RolesAndPermissionDashboardViewBody(),
    );
  }
}
