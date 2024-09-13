import 'package:flutter/material.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

import '../widgets/group_form.dart';

class GroupEditPage extends StatelessWidget {
  final GroupModel group;

  const GroupEditPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GroupForm(group: group), // Pass the group to the form
      ),
    );
  }
}
