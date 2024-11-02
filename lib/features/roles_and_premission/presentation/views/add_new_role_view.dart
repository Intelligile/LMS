import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/add_new_role_view_body.dart';

class AddNewRoleView extends StatelessWidget {
  const AddNewRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfffef7ff),
        ),
        body: const AddNewRoleViewBody());
  }
}
