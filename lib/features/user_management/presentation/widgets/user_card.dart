import 'package:flutter/material.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    Key? key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: 'Edit User',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
                      tooltip: 'Delete User',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("Email: ${user.email}"),
            Text("First Name: ${user.firstname}"),
            Text("Last Name: ${user.lastname}"),
            Text("Phone: ${user.phone}"),
            Text("Enabled: ${user.enabled ? 'Yes' : 'No'}"),
            SizedBox(height: 8),
            // Wrap(
            //   spacing: 8.0,
            //   children: user.authorityIDs
            //       .map((id) => Chip(
            //             label: Text('Role ID: $id'),
            //           ))
            //       .toList(),
            // ),
          ],
        ),
      ),
    );
  }
}
