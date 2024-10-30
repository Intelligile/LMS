import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/presentation/widgets/user_form.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appbar: AppBar(
      //   title: const Text('User Management'),
      //   backgroundColor: kPrimaryColor,
      //   centerTitle: true,
      // ),
      body: AdaptiveLayout(
        mobileLayout: (context) => const SizedBox(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => const UserManagementPageBody(),
      ),
    );
  }
}

class UserManagementPageBody extends StatefulWidget {
  const UserManagementPageBody({super.key});

  @override
  State<UserManagementPageBody> createState() => _UserManagementPageBodyState();
}

class _UserManagementPageBodyState extends State<UserManagementPageBody> {
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
          _users = users;
          _isLoading = false;
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserForm(
          users: users ?? [],
          isEditing: isEditing,
          onSubmit: (List<UserModel> updatedUsers) async {
            try {
              List<String> results = [];

              for (var user in updatedUsers) {
                if (user.id != 0) {
                  String result =
                      await _userRemoteDataSource.updateUser(user, jwtToken);
                  results.add(result);
                } else {
                  String result = await _userRemoteDataSource.addUsers([user]);
                  results.add(result);
                }
              }

              _fetchUsers();

              showSnackBar(context, results.join('\n'), Colors.green);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Active Users',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Action Row
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () => _openUserForm(context, isEditing: false),
                child: const Text('Add User'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {}, // Add functionality here
                child: const Text('User Templates'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {}, // Add functionality here
                child: const Text('Add Multiple Users'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {}, // Add functionality here
                child: const Text('Multi-Factor Authentication'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {}, // Add functionality here
                child: const Text('Delete a User'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Header Row
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Display Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Username',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'License',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // User List
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _users.isEmpty
                      ? const Center(
                          child: Text(
                            'No users found.',
                            style:
                                TextStyle(fontSize: 18, color: kPrimaryColor),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            user.username,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            user.username,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            // user.licenseStatus ??
                                            "Unlicensed",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: kPrimaryColor),
                                              onPressed: () => _openUserForm(
                                                  context,
                                                  users: [user],
                                                  isEditing: true),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.redAccent),
                                              onPressed: () async {
                                                try {
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
                                    ],
                                  ),
                                ),
                                const Divider(height: 1, color: Colors.grey),
                              ],
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
