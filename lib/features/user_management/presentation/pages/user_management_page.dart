import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/presentation/widgets/user_form.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  late UserManagementRemoteDataSource _userRemoteDataSource;
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    Api api = Api(dio);
    _userRemoteDataSource = UserManagementRemoteDataSource(api);
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userRemoteDataSource.getUsers();
      if (mounted) {
        setState(() {
          _users = users; // Update the list of users
          _isLoading = false; // Stop the loading indicator
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      print("Failed to fetch users: $e");
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing async operations or listeners here if necessary
    super.dispose();
  }

  void _openUserForm(BuildContext context,
      {List<UserModel>? users, required bool isEditing}) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserForm(
          users:
              users ?? [], // Initialize with an empty list if no users provided
          isEditing: isEditing, // Pass the flag indicating if editing or adding
          onSubmit: (List<UserModel> updatedUsers) async {
            try {
              List<String> results = [];

              for (var user in updatedUsers) {
                if (user.id != 0) {
                  // Update existing user
                  String result =
                      await _userRemoteDataSource.updateUser(user, jwtToken);
                  results.add(result);
                } else {
                  // Add new user
                  String result = await _userRemoteDataSource.addUsers([user]);
                  results.add(result);
                }
              }

              _fetchUsers(); // Refresh the user list after adding/updating

              // Display combined results
              showSnackBar(context, results.join('\n'), Colors.green);
            } catch (e) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Failed to update users: $e')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _users.isEmpty
                      ? Center(child: Text('No users found.'))
                      : ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return ListTile(
                              title: Text(user.username),
                              subtitle: Text(user.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _openUserForm(context,
                                        users: [user], isEditing: true),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      try {
                                        print(
                                            'Delete button pressed for user ID: ${user.id}');
                                        await _userRemoteDataSource
                                            .removeUser(user.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'User deleted successfully'),
                                          ),
                                        );
                                        // Optionally, update the UI here (e.g., refresh the list)
                                        setState(() {
                                          _fetchUsers();
                                        });
                                      } catch (e) {
                                        print('Exception caught: $e');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed to delete user: $e'),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
                ElevatedButton(
                  onPressed: () => _openUserForm(context, isEditing: false),
                  child: Text('Add User'),
                ),
              ],
            ),
    );
  }
}
