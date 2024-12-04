import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth_code/data/repositories/authorization_code_repository_impl.dart';
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

  final Color primaryColor = Color(0xFF017278); // LMS Primary Color
  final Color accentColor = Colors.white; // Accent color for text on buttons

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
      appBar: AppBar(
        title: Text('User Management', style: TextStyle(color: accentColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: _users.isEmpty
                        ? Center(
                            child: Text('No users found.',
                                style: TextStyle(
                                    fontSize: 18, color: primaryColor)))
                        : ListView.builder(
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              final user = _users[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side:
                                      BorderSide(color: primaryColor, width: 1),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  title: Text(
                                    user.username,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                  subtitle: Text(user.email,
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: primaryColor),
                                        onPressed: () => _openUserForm(context,
                                            users: [user], isEditing: true),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () async {
                                          try {
                                            print(
                                                'Delete button pressed for user ID: ${user.id}');
                                            await _userRemoteDataSource
                                                .removeUser(user.id);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'User deleted successfully'),
                                              ),
                                            );
                                            _fetchUsers();
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
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 16), // Add spacing before the button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // LMS primary color
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _openUserForm(context, isEditing: false),
                    child: Text(
                      'Add User',
                      style: TextStyle(fontSize: 16, color: accentColor),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
