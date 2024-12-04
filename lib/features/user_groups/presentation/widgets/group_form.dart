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
  late final List<int> _usersToRemove = [];

  @override
  void initState() {
    super.initState();
    _selectedUserIds = widget.group?.users.map((user) => user.id).toSet() ?? {};
    _fetchUsers();
    if (widget.group != null) {
      _name = widget.group!.name;
      _description = widget.group!.description;
      widget.group!.users = widget.group?.users ?? [];
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final groupService = GroupRepository(apiService: widget.api);
      _availableUsers = await groupService.fetchUsers();
      _selectedUserIds = _availableUsers
          .where((user) =>
              user.groups.any((group) => group.id == widget.group?.id))
          .map((user) => user.id)
          .toSet();
      setState(() {});
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF017278),
        title: Text(
          widget.group != null ? 'Edit Group' : 'Create Group',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            // Navigate back to the previous page
            GoRouter.of(context).push(AppRouter.kGroupList);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                label: 'Group Name',
                initialValue: _name,
                onSaved: (value) => _name = value ?? '',
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                label: 'Description',
                initialValue: _description,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 20),
              const Text(
                'Assign Users',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF017278)),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildUserList(),
              ),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF017278)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF017278)),
        ),
      ),
      initialValue: initialValue,
      onSaved: onSaved,
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _availableUsers.length,
      itemBuilder: (context, index) {
        final user = _availableUsers[index];
        final isChecked = _selectedUserIds.contains(user.id);
        return CheckboxListTile(
          title: Text(
            '${user.firstname} ${user.lastname}',
            style: const TextStyle(fontSize: 16),
          ),
          value: isChecked,
          activeColor: const Color(0xFF017278),
          onChanged: (bool? selected) {
            setState(() {
              if (selected == true) {
                _selectedUserIds.add(user.id);
                _usersToRemove.remove(user.id);
              } else {
                _selectedUserIds.remove(user.id);
                _usersToRemove.add(user.id);
              }
            });
          },
        );
      },
    );
  }

  Row _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF017278),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          onPressed: _saveGroup,
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        if (widget.group != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () => _showDeleteConfirmation(context),
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Future<void> _saveGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      GroupModel group = GroupModel(
        id: widget.group?.id ?? 0,
        name: _name,
        description: _description,
        users: _availableUsers
            .where((user) => _selectedUserIds.contains(user.id))
            .toList(),
      );

      try {
        final GroupRepository groupService =
            GroupRepository(apiService: widget.api);

        if (widget.group == null) {
          await groupService.createGroup(group);
          await groupService.assignUsersToGroup(
              group.id, _selectedUserIds.toList());
          showSnackBar(context, 'Group inserted successfully', Colors.green);
        } else {
          await groupService.updateGroup(group);
          await _syncGroupUsers(groupService, group.id);
          showSnackBar(context, 'Group updated successfully', Colors.green);
        }

        GoRouter.of(context).go(AppRouter.kGroupList);
      } catch (e) {
        print("ERROR SAVING GROUP $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save group: $e')),
        );
      }
    }
  }

  Future<void> _syncGroupUsers(
      GroupRepository groupService, int groupId) async {
    final currentGroupUsers = widget.group?.users ?? [];
    final currentUserIds = currentGroupUsers.map((user) => user.id).toSet();

    final usersToAdd = _selectedUserIds.difference(currentUserIds);
    final usersToRemove = _usersToRemove.toSet();

    if (usersToAdd.isNotEmpty) {
      await groupService.assignUsersToGroup(groupId, usersToAdd.toList());
    }

    if (usersToRemove.isNotEmpty) {
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
