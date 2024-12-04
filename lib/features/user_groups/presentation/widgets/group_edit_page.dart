import 'package:flutter/material.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

import '../widgets/group_form.dart';

class GroupEditPage extends StatelessWidget {
  final GroupModel group;
  final ApiService api; // Added ApiService parameter

  const GroupEditPage(
      {super.key,
      required this.group,
      required this.api}); // Adjust constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GroupForm(
          group: group,
          api: api, // Pass the api to the form
        ),
      ),
    );
  }
}
