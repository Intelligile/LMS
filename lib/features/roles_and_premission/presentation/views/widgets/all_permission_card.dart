import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/presentation/views/roles_and_permission_dashboard_view.dart';

// Declare the updatedPermission list as a public global variable
List<Permission> updatedPermission = [];

class AllPermissionCard extends StatefulWidget {
  const AllPermissionCard({
    super.key,
    required this.permission,
  });

  final Permission permission;

  @override
  _AllPermissionCardState createState() => _AllPermissionCardState();
}

class _AllPermissionCardState extends State<AllPermissionCard> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    // Initialize isChecked based on whether the permission is in singleRolesPermissions
    isChecked = singleRolesPermissions
        .any((perm) => perm.permission == widget.permission.permission);

    // Ensure already checked permissions are added to the updatedPermission list
    if (isChecked && !updatedPermission.contains(widget.permission)) {
      updatedPermission.add(widget.permission);
    }
  }

  void _onCheckboxChanged(bool? value) {
    setState(() {
      isChecked = value ?? false;

      if (isChecked) {
        // Add permission to updatedPermission list
        if (!updatedPermission.contains(widget.permission)) {
          updatedPermission.add(widget.permission);
        }
      } else {
        // Remove permission from updatedPermission list
        updatedPermission.removeWhere(
            (perm) => perm.permission == widget.permission.permission);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Wrap the Checkbox in a SizedBox or Container
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isChecked,
              onChanged: _onCheckboxChanged,
            ),
          ),
          // Use Flexible to ensure the ListTile takes up remaining space correctly
          Flexible(
            child: ListTile(
              title: Text(widget.permission.permission ?? ''),
              onTap: () {},
              subtitle: Text(widget.permission.permission ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}
