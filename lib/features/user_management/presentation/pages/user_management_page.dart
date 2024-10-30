import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/presentation/widgets/user_form.dart';
import 'package:lms/features/home/presentation/views/widgets/app_bar_grid_and_title.dart';
import 'package:lms/features/home/presentation/views/widgets/app_bar_icons.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_responsive_search_text_field.dart';

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

  void _openUserFormFromRight(BuildContext context,
      {UserModel? user, required bool isEditing}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Allows the background to remain visible
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
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
              child: Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(16.0),
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
                        showSnackBar(context, results.join('\n'), Colors.green);
                      } catch (e) {
                        showSnackBar(
                            context, 'Failed to update users: $e', Colors.red);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        transitionDuration: Duration(milliseconds: 400),
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
                SizedBox(
                    width:
                        16), // Increase spacing between checkbox and username
                Text(user.username,
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppBarGridIconAndTitle(),
            const Expanded(child: SizedBox()),
            const Expanded(flex: 3, child: ResponsiveTextField()),
            const Expanded(flex: 2, child: SizedBox()),
            UserOptionsIcons(
              username: usernamePublic,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Active Users" title with modified font
                  Text(
                    'Active Users',
                    style: TextStyle(
                      fontSize: 28, // Increased font size
                      fontFamily: 'Roboto', // Change to preferred font family
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16), // Padding below title
                  Divider(
                      color: Colors.grey[300],
                      thickness: 1), // Light grey divider

                  // Action buttons with additional options
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            _openUserFormFromRight(context, isEditing: false),
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text('Add a user',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {}, // Placeholder for add group action
                        icon: Icon(Icons.group_add, color: Colors.black),
                        label: Text('Add group',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _fetchUsers, // Refresh action
                        icon: Icon(Icons.refresh, color: Colors.black),
                        label: Text('Refresh',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed:
                            () {}, // Placeholder for export to Excel action
                        icon: Icon(Icons.file_download, color: Colors.black),
                        label: Text('Export to Excel',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Username',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Licenses',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Actions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
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
            ),
    );
  }
}
