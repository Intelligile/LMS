import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/users_view_body.dart';

class UsersView extends StatelessWidget {
  UsersView({super.key, required this.authority});
  Authority authority;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UsersViewBody(authority: authority),
    );
  }
}
