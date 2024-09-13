import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_groups/data/repositories/group_repository.dart';

class GroupForm extends StatefulWidget {
  final GroupModel? group; // Group to edit, if available

  const GroupForm(
      {super.key, this.group}); // Accept group as optional parameter

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  late ApiService api;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    final Dio dio = Dio();
    final Api apiInstance = Api(dio);
    api = ApiService(api: apiInstance);

    if (widget.group != null) {
      _name = widget.group!.name;
      _description = widget.group!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group != null ? 'Edit Group' : 'Create Group'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).push(AppRouter
                .kGroupList); // Navigate back when the back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                initialValue: _name, // Pre-fill if editing
                onSaved: (value) {
                  _name = value ?? '';
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: _description, // Pre-fill if editing
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        GroupModel group = GroupModel(
                          id: widget.group?.id ?? 0, // Use group ID if editing
                          name: _name,
                          description: _description,
                        );

                        try {
                          final GroupRepository groupService =
                              GroupRepository(apiService: api);

                          if (widget.group == null) {
                            // Create new group
                            await groupService.createGroup(group);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Group created successfully!')),
                            );
                          } else {
                            // Update existing group
                            await groupService.updateGroup(group);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Group updated successfully!')),
                            );
                          }

                          GoRouter.of(context).push(AppRouter.kGroupList);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save group: $e')),
                          );
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                  if (widget.group !=
                      null) // Show delete button only if editing
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red color for delete
                      ),
                      onPressed: () async {
                        _showDeleteConfirmation(context);
                      },
                      child: const Text('Delete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // Show confirmation dialog
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this group?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Red text for danger
              ),
              onPressed: () async {
                // Call delete functionality here
                try {
                  final GroupRepository groupService =
                      GroupRepository(apiService: api);

                  await groupService.deleteGroup(widget.group!.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Group deleted successfully!')),
                  );

                  Navigator.of(dialogContext).pop(); // Close the dialog
                  GoRouter.of(context).go(AppRouter.kGroupList);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete group: $e')),
                  );
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
