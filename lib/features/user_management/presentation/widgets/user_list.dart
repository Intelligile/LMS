import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

import 'user_card.dart';

class UserListPage extends StatefulWidget {
  final Function(UserModel) onEditUser;

  UserListPage({required this.onEditUser});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Dio dio;
  late Api api;
  late UserManagementRemoteDataSource _userRemoteDataSource;
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    api = Api(dio);
    _userRemoteDataSource = UserManagementRemoteDataSource(api);
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userRemoteDataSource.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Failed to fetch users: $e");
    }
  }

  void _onDeleteUser(UserModel user) async {
    try {
      await _userRemoteDataSource.removeUser(user.id);
      _fetchUsers(); // Refresh the list after deletion
    } catch (e) {
      print("Failed to delete user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return UserCard(
                user: user,
                onEdit: () => widget.onEditUser(user),
                onDelete: () => _onDeleteUser(user),
              );
            },
          );
  }
}
