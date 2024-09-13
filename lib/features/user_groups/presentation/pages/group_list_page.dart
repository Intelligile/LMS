import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

import 'package:lms/features/user_groups/presentation/widgets/group_card.dart';
import 'package:lms/core/utils/app_router.dart';

class GroupListPage extends StatelessWidget {
  final ApiService _apiService;

  GroupListPage({super.key}) : _apiService = ApiService(api: Api(Dio()));

  Future<List<GroupModel>> _fetchGroups() async {
    try {
      return await _apiService.fetchGroups();
    } catch (e) {
      // Log the exception details
      print('Exception occurred while fetching groups: $e');
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Groups'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).push(AppRouter
                .kHomeView); // Navigate back when the back button is pressed
          },
        ),
      ),
      body: FutureBuilder<List<GroupModel>>(
        future: _fetchGroups(),
        builder: (context, snapshot) {
          // Print the connection state for debugging
          print('Connection state: ${snapshot.connectionState}');
          // Print whether data is available or not
          print('Has data: ${snapshot.hasData}');
          // Print whether there is an error
          print('Has error: ${snapshot.hasError}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error details: ${snapshot.error}');
            return const Center(child: Text('Failed to load groups'));
          } else if (snapshot.hasData) {
            List<GroupModel>? groups = snapshot.data;
            if (groups == null || groups.isEmpty) {
              return const Center(child: Text('No groups available'));
            }
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return GroupCard(group: groups[index]);
              },
            );
          } else {
            return const Center(child: Text('Unexpected error'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go(AppRouter.kAddGroup);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
