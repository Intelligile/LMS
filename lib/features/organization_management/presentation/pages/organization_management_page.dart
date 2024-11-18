import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
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
        body: AdaptiveLayout(
      mobileLayout: (context) => const SizedBox(),
      tabletLayout: (context) => const SizedBox(),
      desktopLayout: (context) => const UserManagementPageBody(),
    ));
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

  final Color primaryColor = const Color(0xFF017278); // LMS Primary Color
  final Color accentColor = Colors.white; // Accent color for text on buttons
  String _organizationName = '';

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
      final users = await _userRemoteDataSource.getOrganizationUsers();
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;

          // Extract organization name from the first user
          if (_users.isNotEmpty && _users[0].organization != null) {
            _organizationName = _users[0].organization?.name ?? '';
          }
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

  void _openUserFormFromRight(BuildContext context,
      {UserModel? user, required bool isEditing}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Allows the background to remain visible
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(animation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.6, // 60% width of screen
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(-4, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UserForm(
                      users: user != null ? [user] : [],
                      isEditing: isEditing,
                      onSubmit: (List<UserModel> updatedUsers) async {
                        try {
                          List<String> results = [];
                          for (var user in updatedUsers) {
                            if (user.id != 0) {
                              String result = await _userRemoteDataSource
                                  .updateUser(user, jwtToken);
                              results.add(result);
                            } else {
                              String result =
                                  await _userRemoteDataSource.addUsers([user]);
                              results.add(result);
                            }
                          }
                          _fetchUsers();
                          Navigator.of(context).pop();
                          showSnackBar(
                              context, results.join('\n'), Colors.green);
                        } catch (e) {
                          showSnackBar(context, 'Failed to update users: $e',
                              Colors.red);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

//  Modify delete icon appearance in _buildUserListDataRow
  DataRow _buildUserListDataRow(UserModel user) {
    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () =>
                _openUserFormFromRight(context, user: user, isEditing: true),
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? newValue) {},
                ),
                const SizedBox(
                    width:
                        16), // Increase spacing between checkbox and username
                Text('${user.firstname} ${user.lastname}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        DataCell(Text(user.email)),
        DataCell(Text(user.phone ?? "Unlicensed")),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete_outline, color: primaryColor),
            onPressed: () async {
              try {
                await _userRemoteDataSource.removeUser(user.id);
                showSnackBar(
                    context, 'User deleted successfully', Colors.green);
                _fetchUsers();
              } catch (e) {
                showSnackBar(context, 'Failed to delete user: $e', Colors.red);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBreadcrumb(
                  items: const ['Home', 'Active users'],
                  onTap: (index) {
                    // Add navigation logic based on index
                    if (index == 0) {
                      GoRouter.of(context).go(AppRouter.kHomeView);
                    } else if (index == 1) {
                      // Navigate to Active Users
                    }
                  },
                ),

                // "Active Users" title with modified font
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Active Users',
                  style: TextStyle(
                    fontSize: 28, // Increased font size
                    fontFamily: 'Avenir', // Change to preferred font family
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16), // Padding below title
                Divider(
                    color: Colors.grey[300],
                    thickness: 1), // Light grey divider

                // Action buttons with additional options
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          _openUserFormFromRight(context, isEditing: false),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Add a user',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {}, // Placeholder for add group action
                      icon: const Icon(Icons.group_add, color: Colors.black),
                      label: const Text('Add group',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _fetchUsers, // Refresh action
                      icon: const Icon(Icons.refresh, color: Colors.black),
                      label: const Text('Refresh',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed:
                          () {}, // Placeholder for export to Excel action
                      icon:
                          const Icon(Icons.file_download, color: Colors.black),
                      label: const Text('Export to Excel',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                    color: Colors.grey[300],
                    thickness: 1), // Light grey divider

                // User table
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: DataTable(
                        dividerThickness: 1,
                        columnSpacing: 24.0,
                        columns: const [
                          DataColumn(
                              label: Text('Display Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Username',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Licenses',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Actions',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: _users
                            .map((user) => _buildUserListDataRow(user))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
