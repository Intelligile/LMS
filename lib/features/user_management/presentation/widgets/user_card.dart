import 'package:flutter/material.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: 'Edit User',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      tooltip: 'Delete User',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Email: ${user.email}"),
            Text("First Name: ${user.firstname}"),
            Text("Last Name: ${user.lastname}"),
            Text("Phone: ${user.phone}"),
            Text("Enabled: ${user.enabled ? 'Yes' : 'No'}"),
            const SizedBox(height: 8),
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
