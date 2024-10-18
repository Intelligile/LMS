import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_groups/data/repositories/group_repository.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class GroupForm extends StatefulWidget {
  final GroupModel? group;
  final ApiService api;

  const GroupForm({super.key, this.group, required this.api});

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  late List<UserModel> _availableUsers = [];
  late Set<int> _selectedUserIds;
  late final List<int> _usersToRemove = []; // New list to track unchecked users

  @override
  void initState() {
    super.initState();
    _selectedUserIds = widget.group?.users.map((user) => user.id).toSet() ?? {};
    _fetchUsers();
    if (widget.group != null) {
      _name = widget.group!.name;
      _description = widget.group!.description;
      widget.group!.users = widget.group?.users ?? [];
      print('Loaded group users: ${widget.group?.users}');
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final groupService = GroupRepository(apiService: widget.api);
      _availableUsers = await groupService.fetchUsers();

      // Debugging prints
      print('Available users: $_availableUsers');
      print('Group users: ${widget.group?.users}');

      // Initialize _selectedUserIds based on the group ID
      _selectedUserIds = _availableUsers
          .where((user) =>
              user.groups.any((group) => group.id == widget.group?.id))
          .map((user) => user.id)
          .toSet();

      print('Selected user IDs: $_selectedUserIds');

      setState(() {});
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group != null ? 'Edit Group' : 'Create Group'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                initialValue: _name,
                onSaved: (value) => _name = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: _description,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 20),
              const Text('Assign Users',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = _availableUsers[index];
                    final isChecked = _selectedUserIds.contains(user.id);
                    return CheckboxListTile(
                      title: Text('${user.firstname} ${user.lastname}'),
                      value: isChecked,
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedUserIds.add(user.id);
                            _usersToRemove.remove(user
                                .id); // Remove from removal list if rechecked
                          } else {
                            _selectedUserIds.remove(user.id);
                            _usersToRemove.add(user.id); // Add to removal list
                            print(
                                'SELECTED USERS AFTER UNCHECKING: $_selectedUserIds');
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        GroupModel group = GroupModel(
                          id: widget.group?.id ?? 0,
                          name: _name,
                          description: _description,
                          users: _availableUsers
                              .where(
                                  (user) => _selectedUserIds.contains(user.id))
                              .toList(),
                        );

                        try {
                          final GroupRepository groupService =
                              GroupRepository(apiService: widget.api);

                          if (widget.group == null) {
                            await groupService.createGroup(group);
                            await groupService.assignUsersToGroup(
                                group.id, _selectedUserIds.toList());
                            showSnackBar(context, 'Group inserted successfully',
                                Colors.green);
                          } else {
                            await groupService.updateGroup(group);
                            await _syncGroupUsers(groupService, group.id);
                            showSnackBar(context, 'Group updated successfully',
                                Colors.green);
                          }

                          GoRouter.of(context).go(AppRouter.kGroupList);
                        } catch (e) {
                          print("ERROR SAVING GROUP $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save group: $e')),
                          );
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                  if (widget.group != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _showDeleteConfirmation(context),
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

  Future<void> _syncGroupUsers(
      GroupRepository groupService, int groupId) async {
    final currentGroupUsers = widget.group?.users ?? [];
    print("Current group users $currentGroupUsers");
    final currentUserIds = currentGroupUsers.map((user) => user.id).toSet();

    final usersToAdd = _selectedUserIds.difference(currentUserIds);
    final usersToRemove = _usersToRemove.toSet(); // Use the usersToRemove list

    print("CURRENT USERS ID $currentUserIds");
    if (usersToAdd.isNotEmpty) {
      await groupService.assignUsersToGroup(groupId, usersToAdd.toList());
    }

    if (usersToRemove.isNotEmpty) {
      print("USERS TO REMOVE $usersToRemove");
      await groupService.revokeUsersFromGroup(groupId, usersToRemove.toList());
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this group?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                try {
                  final GroupRepository groupService =
                      GroupRepository(apiService: widget.api);
                  await groupService.deleteGroup(widget.group!.id);
                  showSnackBar(
                      context, 'Group deleted successfully', Colors.red);
                  Navigator.of(dialogContext).pop();
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
