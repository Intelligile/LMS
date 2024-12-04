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
        // Navigate to the Group Details page, passing the group data as extra
        GoRouter.of(context).go(AppRouter.kGroupDetails, extra: group);
      },
      child: Card(
        elevation: 3, // Adding some elevation for a shadow effect
        margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0), // Giving some spacing around the card
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Rounded corners for the card
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.all(16.0), // Add padding inside the ListTile
          title: Text(
            group.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16), // Style for group name
          ),
          subtitle: Text(
            group.description,
            maxLines: 2, // Limit the description to two lines
            overflow:
                TextOverflow.ellipsis, // Use ellipsis if the text overflows
            style: TextStyle(
                color: Colors.grey[600]), // Grey color for the subtitle text
          ),
        ),
      ),
    );
  }
}
