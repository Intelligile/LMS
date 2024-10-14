import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/update_roles_view_body.dart';

class UpdateRolesView extends StatelessWidget {
  const UpdateRolesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffef7ff),
      ),
      body: UpdateRolesViewBody(),
    );
  }
}
