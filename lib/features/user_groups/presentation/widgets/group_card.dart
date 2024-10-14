import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;

  const GroupCard({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).go(AppRouter.kGroupDetails, extra: group);
      },
      child: Card(
        child: ListTile(
          title: Text(group.name),
          subtitle: Text(group.description),
        ),
      ),
    );
  }
}
